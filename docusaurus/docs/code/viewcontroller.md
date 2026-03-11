---
id: view-controller
title: ViewController – Die zentrale Steuerung
sidebar_label: ViewController
---

# ViewController

Der `ViewController` ist das Herzstück des Frontends. Er fungiert als Bindeglied zwischen den JPA-Repositories, der
Geschäftslogik (Services) und den JSP-Views. Er nutzt ein zentrales **Layout-System**, bei dem die Zielseite als
`contentPage` Variable an das `main-layout` übergeben wird.

---

## 1. Kernstruktur & Navigation

### Konstruktor & Injection

Der Controller nutzt **Constructor Injection**, um Repositories und Services bereitzustellen. Dies stellt sicher, dass
alle Abhängigkeiten beim Start der Anwendung vorhanden sind.

### Dashboard & Basis-Navigation

Beim Aufruf der Startseite werden die aktuellsten Daten aggregiert, um dem Administrator eine schnelle Übersicht zu
ermöglichen.

* **Username**: Wird über `@AuthenticationPrincipal` aus dem Security-Kontext bezogen.
* **Ziehungen**: Lädt die jeweils letzte Ziehung beider Lotterien.

```java 

@GetMapping({"/", "/home"})
public String index(@AuthenticationPrincipal UserDetails userDetails, Model model) {
    if (userDetails != null) {
        model.addAttribute("username", userDetails.getUsername());
    }

    model.addAttribute("allPlayers", playerRepository.findAll());

    GameDrawEuro euroDaten = gameDrawEuroRepository.findTopByOrderByIdDesc();
    GameDrawLotto lottoDaten = gameDrawLottoRepository.findTopByOrderByIdDesc();

    if (euroDaten != null) model.addAttribute("gameDrawEuro", euroDaten);
    if (lottoDaten != null) model.addAttribute("gameDrawLotto", lottoDaten);

    model.addAttribute("contentPage", "/WEB-INF/jsp/pages/dashboard.jsp");
    return "layout/main-layout";
}
```

### Addon-Seiten

Dynamisches Laden der Ziehungstabellen für Lotto oder Eurojackpot basierend auf dem Pfad-Parameter `/addons/{page}`.

---

## 2. Spieler-Verwaltung (Player Management)

Dieses Modul steuert die Stammdaten der Teilnehmer mit Fokus auf Sicherheit und Benutzerfreundlichkeit.

### Dynamische Sortierung und Suche

Um SQL-Injection zu verhindern, implementiert der Controller einen Sicherheits-Check für Sortierfelder. Es werden nur
explizit erlaubte Datenbankspalten für die Sortierung akzeptiert.

```java
public String loadPlayers(@RequestParam String sortField, @RequestParam String sortDir, Model model) {
// Erlaubte Sortierfelder definieren
    List<String> allowedFields = List.of(
            "id", "username", "spieltMitSeit",
            "spiele", "kontostand", "status"
    );

// Fallback auf 'id', falls ein ungültiges Feld übergeben wurde
    if (!allowedFields.contains(sortField)) {
        sortField = "id";
    }

    Sort sort = sortDir.equalsIgnoreCase("asc") ?
            Sort.by(sortField).ascending() :
            Sort.by(sortField).descending();
}
```

### Spieler-Aktionen (CRUD)

* **Anlegen**: Verarbeitet POST-Anfragen. Da der Dialog als Modal implementiert ist, wird eine `ResponseEntity`
  zurückgegeben, um dem JavaScript-Frontend präzise Statusmeldungen (z. B. bei Namenskollisionen) zu senden.
* **Bearbeiten/Löschen**: Standard-Methoden zur Aktualisierung und Entfernung von Spielerdatensätzen.

```java

@PostMapping("/management/player/add")
@ResponseBody
public ResponseEntity<?> addPlayer(
        @RequestParam String username,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate spieltMitSeit,
        @RequestParam String spiele,
        @RequestParam BigDecimal kontostand,
        @RequestParam String status
) {
    try {
        Player player = new Player();
        player.setUsername(username);
        player.setSpieltMitSeit(spieltMitSeit);
        player.setSpiele(spiele);
        player.setKontostand(kontostand);
        player.setStatus(status);

        playerRepository.save(player);
        return ResponseEntity.ok().build();

    } catch (org.springframework.dao.DataIntegrityViolationException e) {
        // 409 Conflict bei doppeltem Usernamen
        return ResponseEntity.status(org.springframework.http.HttpStatus.CONFLICT)
                .body("Der Spielername '" + username + "' ist bereits vergeben.");
    } catch (Exception e) {
        return ResponseEntity.internalServerError()
                .body("Ein unerwarteter Fehler ist aufgetreten.");
    }
}
```

---

## 3. Ticket-System & Logik

Die Ticket-Verwaltung ist der komplexeste Teil, da sie zwischen verschiedenen Lotterietypen unterscheidet und
mathematische Berechnungen anstößt.

### Ticket-Erstellung & Feld-Parsing

Da das Frontend die angekreuzten Zahlen als kompakten, Pipe-separierten String sendet, übernimmt der Controller das
Parsing in die entsprechenden Datenbank-Modelle (`LottoField` / `EuroField`).

```java
public String addTicket(@RequestParam String fieldsInput, ...) {
    // Logik: String am Pipe-Symbol splitten und einzelne Felder extrahieren
    List<LottoField> fields = new ArrayList<>();
    String[] fieldArr = fieldsInput.split("\\|");

    for (String f : fieldArr) {
        if (f.isBlank()) continue;
        String[] parts = f.split(",");
        String numbers = String.join(",", Arrays.copyOfRange(parts, 0, 6));
        Integer superNumber = Integer.parseInt(parts[6]);

        LottoField field = new LottoField();
        field.setNumbers(numbers);
        field.setSuperNumber(superNumber);
        field.setLottoTicket(ticket);
        fields.add(field);
    }
    ticket.setFields(fields);
}
```

### Preisberechnung vor Speicherung

Bevor ein Ticket persistent in der Datenbank gespeichert wird, erfolgt die finale Preiskalkulation über den
`TicketPriceService`.

```
BigDecimal total = ticketPriceService.calcLottoPrice(
        fields.size(),
        ticket.isWednesday(),
        ticket.isSaturday(),
        weeks,
        spiel77,
        super6,
        glueck
);
ticket.setTotalPrice(total);
lottoTicketRepository.save(ticket);
```

---

## 4. Fortgeschrittene Update-Logik

Beim Bearbeiten von Tickets wird eine spezielle Methode angewandt, um die Referenzintegrität der Spielfelder zu wahren (
Orphan Removal). Anstatt die gesamte Liste der Felder zu ersetzen, wird die bestehende Liste geleert und neu befüllt.
Dies verhindert Probleme mit dem Hibernate-Lifecycle.

```java

@PostMapping("/management/ticket/edit/{gameType}/{id}")
public String updateTicket(@PathVariable Long id, @RequestParam String fieldsInput, ...) {
    // Logik: Bestehende Felder leeren, damit Hibernate die Waisenkinder löscht
    ticket.getFields().clear();

    // Logik: Neue Felder aus dem Input generieren
    List<LottoField> newFields = new ArrayList<>();
    // ... (Parsing)

    // WICHTIG: Bestehende Liste befüllen statt Referenz zu ersetzen
    ticket.getFields().addAll(newFields);
    lottoTicketRepository.save(ticket);
}
```

---

## 5. Systemfunktionen & Hilfsmittel

### Externe Dokumentation

Um dem Administrator schnellen Zugriff auf die technische Hilfe zu geben, existiert ein Endpunkt, der direkt auf den
Dokumentations-Server weiterleitet.

```java

@GetMapping("/documentation")
public String docs() {
// Leitet auf den lokalen Docusaurus-Server weiter
    return "redirect:http://localhost:3000/docs/intro"; // localhost muss mit ip ersetzt werden.
}
```