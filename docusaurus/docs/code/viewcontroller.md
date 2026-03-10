---
id: view-controller
title: ViewController – Die zentrale Steuerung
sidebar_label: View Controller
---

# ViewController

Der `ViewController` ist der primäre Controller der Anwendung. Er verwaltet das Routing, die Datenaufbereitung für die
JSP-Views und die Interaktion zwischen dem Frontend und den Repositories.

## Kernstruktur & Konstruktor

Der Controller nutzt **Constructor Injection**, um alle notwendigen Repositories und Services bereitzustellen. Dies
sorgt für eine saubere Testbarkeit und stellt sicher, dass alle Abhängigkeiten beim Start der Anwendung vorhanden sind.

---

## Basis-Navigation

### Login & Dashboard

* **Login (`/login`)**: Liefert die Login-Seite aus.
* **Dashboard (`/`, `/home`)**: Bereitet die Daten für die Startseite auf. Hierzu gehören:
    * Der aktuelle Username aus dem `SecurityContext`.
    * Eine Liste aller Spieler für Schnellzugriffe.
    * Die jeweils aktuellsten Ziehungsdaten für Lotto und Eurojackpot.

### Addon-Seiten

* **Ziehungs-Tabellen (`/addons/{page}`)**: Dynamisches Laden der Ziehungstabellen für Lotto oder Eurojackpot basierend
  auf dem Pfad-Parameter.

---

## Spieler-Verwaltung (Management)

Dieser Abschnitt steuert die CRUD-Operationen (Create, Read, Update, Delete) für die Teilnehmer.

### Spieler auflisten & Suchen

* **`loadPlayers`**:
    * Unterstützt die Suche über Keywords.
    * Implementiert eine dynamische Sortierung (Asc/Desc) basierend auf erlaubten Feldern.
    * Berechnet die Umkehrung der Sortierrichtung für die Tabellen-Header.

### Spieler hinzufügen

* **`addPlayer`**:
    * Verarbeitet POST-Anfragen über `@ResponseBody`.
    * **Fehlerbehandlung**: Prüft auf `DataIntegrityViolationException` (z. B. wenn ein Username bereits existiert) und
      sendet entsprechende HTTP-Statuscodes (409 Conflict) an das Frontend zurück.

### Spieler bearbeiten & löschen

* **`updatePlayer`**: Aktualisiert die Stammdaten eines bestehenden Spielers.
* **`deletePlayer`**: Entfernt den Spieler und alle verknüpften Daten aus der Datenbank.

### Spielerprofil

* **`viewPlayerProfile`**:
    * Lädt die Detailansicht eines Spielers.
    * Aggregiert Lotto- und Euro-Tickets in einer gemeinsamen Liste für eine lückenlose Historie.

---

## Ticket-Verwaltung

Die Ticket-Steuerung ist aufgrund der verschiedenen Lotterietypen und der komplexen Preiskalkulation der umfangreichste
Teil des Controllers.

### Ticket-Übersicht

* **`loadTickets`**:
    * Nutzt die `TicketOverviewRepository` (Subselect-View), um Lotto- und Euro-Tickets gemeinsam anzuzeigen.
    * **Optimierung**: Implementiert eine Paginierung (`PageRequest`), um bei großen Datenmengen nur die ersten 10
      Einträge zu laden.

### Ticket erstellen

* **`addTicket`**:
    * Unterscheidet zwischen `LOTTO` und `EURO`.
    * **Parsing**: Zerlegt den `fieldsInput` (vom Frontend als Pipe-separierter String gesendet) in einzelne `Field`
      -Objekte.
    * **Preiskalkulation**: Ruft den `TicketPriceService` auf, um den Gesamtpreis vor dem Speichern zu ermitteln.

### Ticket bearbeiten

* **`updateTicket`**:
    * Ermöglicht die Korrektur von Losnummern, Laufzeiten und Spielfeldern.
    * **Hibernate-Optimierung**: Bestehende Feld-Listen werden geleert und neu befüllt, anstatt die Liste komplett zu
      ersetzen, um die Referenzintegrität (Orphan Removal) zu wahren.

### Ticket-Details & Löschen

* **`getTicketDetails`**: Liefert Ticket-Daten als JSON für die Modal-Fenster im Frontend.
* **`deleteTicket`**: Löscht das Ticket aus dem jeweiligen Repository basierend auf dem `gameType`.

---

## Systemfunktionen

### Fehlerbehandlung & Dokumentation

* **Error (`/error`)**: Standard-Route für Fehlermeldungen innerhalb des Layout-Systems.
* **Dokumentation (`/documentation`)**: Ein direkter Redirect auf die Docusaurus-Dokumentation (Port 3000), um dem
  Administrator Hilfestellungen zu bieten.

---

# ViewController

Der `ViewController` ist das Herzstück des Frontends. Er fungiert als Bindeglied zwischen den JPA-Repositories, der
Geschäftslogik (Services) und den JSP-Views. Er nutzt ein zentrales **Layout-System**, bei dem die Zielseite als
`contentPage` Variable an das `main-layout` übergeben wird.

---

## 1. Dashboard & Basis-Navigation

Das Dashboard aggregiert Daten aus verschiedenen Quellen, um dem Administrator eine schnelle Übersicht zu ermöglichen.

### Dashboard-Initialisierung

Beim Aufruf von `/home` werden die aktuellsten Ziehungen beider Lotterien geladen.

```java

@GetMapping({"/", "/home"})
public String index(@AuthenticationPrincipal UserDetails userDetails, Model model) {
    // Aktuellste Ziehungen abrufen
    GameDrawEuro euroDaten = gameDrawEuroRepository.findTopByOrderByIdDesc();
    GameDrawLotto lottoDaten = gameDrawLottoRepository.findTopByOrderByIdDesc();

    if (euroDaten != null) model.addAttribute("gameDrawEuro", euroDaten);
    if (lottoDaten != null) model.addAttribute("gameDrawLotto", lottoDaten);

    model.addAttribute("contentPage", "/WEB-INF/jsp/pages/dashboard.jsp");
    return "layout/main-layout";
}
```

2. Spieler-Verwaltung (Player Management)
   Dieses Modul steuert die Stammdaten der Teilnehmer. Ein Fokus liegt hier auf der dynamischen Sortierung und der
   Validierung.

Dynamische Sortierung und Suche
Um SQL-Injection zu verhindern, werden nur explizit erlaubte Sortierfelder akzeptiert.

```Java
// Sicherheits-Check für Sortierfelder
List<String> allowedFields = List.of("id", "username", "spieltMitSeit", "kontostand", "status");
if(!allowedFields.

contains(sortField)){
sortField ="id"; // Fallback
        }
```

Sort sort = sortDir.equalsIgnoreCase("asc") ? Sort.by(sortField).ascending() : Sort.by(sortField).descending();
Spieler hinzufügen (API-Response)
Da der Spieler-Dialog als Modal implementiert ist, antwortet der Controller hier mit ResponseEntity, um dem Frontend (
JavaScript) präzise Rückmeldungen zu geben.

```Java

@PostMapping("/management/player/add")
@ResponseBody
public ResponseEntity<?> addPlayer(@RequestParam String username, ...) {
    try {
// ... Logik zum Speichern
        return ResponseEntity.ok().build();
    } catch (org.springframework.dao.DataIntegrityViolationException e) {
// Spezifischer Fehler, falls der Username (Unique Constraint) bereits existiert
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body("Der Spielername '" + username + "' ist bereits vergeben.");
    }
}
```

3. Ticket-System & Logik
   Die Ticket-Verwaltung ist der komplexeste Teil des Controllers, da sie zwischen Lotto- und Euro-Logik unterscheidet
   und Preise berechnet.

Ticket-Erstellung & Feld-Parsing
Das Frontend sendet die angekreuzten Zahlen als einen kompakten String (z.B. durch Pipes | getrennt). Der Controller
parst diesen String in die entsprechenden Datenbank-Modelle.

```Java
// Beispiel: Parsing von Lotto-Feldern
String[] fieldArr = fieldsInput.split("\\|"); // Trennung der Tipp-Reihen
for(
String f :fieldArr){
String[] parts = f.split(",");
String numbers = String.join(",", Arrays.copyOfRange(parts, 0, 6)); // Zahlen 1-6
Integer superNumber = Integer.parseInt(parts[6]); // 7. Wert ist Superzahl

LottoField field = new LottoField();
    field.

setNumbers(numbers);
    field.

setSuperNumber(superNumber);
// ...

}
```

Preisberechnung vor Speicherung
Bevor ein Ticket in der Datenbank landet, wird der TicketPriceService aufgerufen.

```Java
BigDecimal total = ticketPriceService.calcLottoPrice(
        fields.size(),
        ticket.isWednesday(),
        ticket.isSaturday(),
        weeks,
        spiel77, super6, glueck);

ticket.

setTotalPrice(total);
lottoTicketRepository.

save(ticket);
```

4. Ticket-Bearbeitung (Update-Logik)
   Beim Bearbeiten von Tickets wird eine spezielle Methode angewandt, um die Referenzintegrität der Spielfelder zu
   wahren, ohne die gesamte Liste neu instanziieren zu müssen.

```Java
// Bestehende Felder leeren, damit Hibernate die Waisenkinder (Orphans) löscht
ticket.getFields().

clear();

// Neue Felder basierend auf dem Input erstellen
List<LottoField> newFields = // ... Parsing Logik
        ticket.getFields().addAll(newFields); // Bestehende Liste neu befüllen
```

5. Hilfsfunktionen & Redirects
   Externe Dokumentation
   Um dem Administrator schnellen Zugriff auf diese Docusaurus-Dokumentation zu geben, existiert ein spezieller
   Endpunkt:

```Java

@GetMapping("/documentation")
public String docs() {
// Leitet direkt auf den Dokumentations-Server (Port 3000) weiter
    return "redirect:http://localhost:3000/docs/intro";
}
```