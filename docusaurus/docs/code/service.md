---
id: services
title: Business Logic & Services
sidebar_label: Services
---

# Business Logic & Services

Die Service-Schicht kapselt die komplexe Geschäftslogik der Anwendung. Während Repositories nur für den Datenbankzugriff
zuständig sind, verarbeiten Services die Daten, bevor sie gespeichert oder angezeigt werden.

---

## DataImportService

Der `DataImportService` ist dafür zuständig, externe JSON-Daten (die durch die Shell-Skripte wie `./pullLotto.sh`
geladen wurden) in das System zu importieren.

### Der Quellcode

```java

@Service
public class DataImportService {

    private final GameDrawLottoRepository lottoRepo;
    private final GameDrawEuroRepository euroRepo;

    public DataImportService(GameDrawLottoRepository lottoRepo,
                             GameDrawEuroRepository euroRepo) {
        this.lottoRepo = lottoRepo;
        this.euroRepo = euroRepo;
    }

    public void importJsonData(String filePath) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(new File(filePath));

        // --- LOTTO-VERARBEITUNG ---
        JsonNode lottoGewinn = root.get("lotto_gewinnzahlen");
        // ... (Check auf Null-Werte)
        if (lottoRepo.findByGameDate(lottoDate).isEmpty()) {
            GameDrawLotto lotto = new GameDrawLotto();
            // Mapping der JSON-Felder auf das Model
            lotto.setJackpot(new BigDecimal(lottoJackpot.get("ErwarteterJackpot1").asText()));
            lottoRepo.save(lotto);
        }

        // --- EUROJACKPOT-VERARBEITUNG ---
        JsonNode euroGewinn = root.get("eurojackpot_gewinnzahlen");
        // ... (Analoge Verarbeitung für Eurojackpot)
        if (euroRepo.findByGameDate(euroDate).isEmpty()) {
            GameDrawEuro euro = new GameDrawEuro();
            euroRepo.save(euro);
        }
    }
}
```

1. Constructor Injection (Die Werkzeuge)
   Statt @Autowired nutzt du hier die Constructor Injection. Das ist "Clean Code", weil der Service ohne die beiden
   Repositories gar nicht erst gestartet werden kann. Er verlangt beim Erstellen sofort nach dem Zugriff auf die Lotto-
   und Euro-Tabellen.

2. JSON-Parsing mit Jackson
   Mit dem ObjectMapper liest du das Dateisystem aus. Der JsonNode root ist der Einstiegspunkt in den gesamten Baum
   deiner JSON-Datei. Über root.get("...") hangelst du dich tiefer in die Struktur der Datei (z.B. zu den Gewinnzahlen
   oder dem Jackpot).

3. Dubletten-Schutz (Existenzprüfung)
   Das ist ein sehr wichtiger Teil:

```Java
if(lottoRepo.findByGameDate(lottoDate).

isEmpty())
```

Bevor der Service neue Zahlen speichert, prüft er anhand des Datums (gameDate), ob diese Ziehung bereits in der
Datenbank existiert. Ohne diese Prüfung hättest du nach jedem Skript-Lauf die gleichen Ziehungen mehrfach in der
Datenbank.

4. Datentyp-Konvertierung
   Da JSON fast alles als Text (String) liefert, führt der Service wichtige Umwandlungen durch:

BigDecimal: Der Jackpot wird von Text in BigDecimal umgewandelt, damit im System präzise mit dem Geldwert gerechnet
werden kann.

String-Repräsentation: Die Zahlenlisten werden im JSON als Array geliefert und hier sauber für die Speicherung in der
H2-Datenbank vorbereitet.

5. Fehlerbehandlung (Robusheit)
   Der Service prüft mit if (lottoGewinn != null && ...), ob alle erwarteten Felder in der Datei vorhanden sind. Fehlt
   ein Teil der Daten (z.B. weil die API-Antwort fehlerhaft war), stürzt das Programm nicht ab, sondern gibt eine
   Warnmeldung in der Konsole aus.

---

## TicketPriceService

Der `TicketPriceService` ist die zentrale Komponente für die Abrechnung. Er berechnet dynamisch den Gesamtpreis eines
Tippscheins basierend auf der Anzahl der Felder, den gewählten Ziehungstagen und den aktivierten Zusatzspielen.

### Der Quellcode

```java

@Service
public class TicketPriceService {

    private static final BigDecimal LOTTO_FIELD_PRICE = BigDecimal.valueOf(1.20);
    private static final BigDecimal EURO_FIELD_PRICE = BigDecimal.valueOf(2.00);

    private static final BigDecimal SPIEL77 = BigDecimal.valueOf(2.50);
    private static final BigDecimal SUPER6 = BigDecimal.valueOf(1.25);
    private static final BigDecimal GLUECK = BigDecimal.valueOf(5.00);

    // Berechnung für Lotto 6aus49
    public BigDecimal calcLottoPrice(int fieldCount, boolean mi, boolean sa, int weeks, ...) {
        // Logik zur Preisermittlung...
    }

    // Berechnung für Eurojackpot
    public BigDecimal calcEuroPrice(int fieldCount, boolean fr, boolean di, ...) {
        // Logik zur Preisermittlung...
    }
}
```

Erläuterung der Preiskalkulation (Deep Dive)
Hier wird die mathematische Logik hinter der Preisermittlung der Tippscheine im Detail erläutert:

1. Konstante Preisstruktur
   Die Anwendung nutzt static final BigDecimal Werte für die Preise (z. B. 1,20 € pro Lottofeld). Dies ist
   architektonisch vorteilhaft, da diese Werte unveränderlich (immutable) sind. Sollte die Lottogesellschaft die Preise
   anpassen, müssen die Änderungen nur an dieser einen zentralen Stelle im Code vorgenommen werden.

2. Multiplikator-Logik (Die Ziehungstage)
   Der Service ermittelt zunächst die Anzahl der Ziehungen pro Woche, an denen der Schein teilnimmt:

Lotto 6aus49: Mittwoch (mi) und Samstag (sa).

Eurojackpot: Dienstag (di) und Freitag (fr).

Daraus ergibt sich der Faktor drawsPerWeek. Wählt ein Nutzer beide verfügbaren Tage, verdoppeln sich sowohl der
Basispreis der Felder als auch die Kosten für die gewählten Zusatzspiele automatisch.

3. Berechnung der Zusatzspiele
   Zusatzoptionen wie Spiel 77, Super 6 oder die Glücksspirale werden pro Ziehungstag berechnet. Der Service addiert
   alle aktiven Optionen zu einem extraPerDraw-Betrag und multipliziert diesen anschließend mit der Anzahl der
   tatsächlichen Ziehungen.

4. Wochenfaktor (Laufzeit)
   Speziell bei Lotto-Tickets wird der Parameter weeks (Wochenlaufzeit) berücksichtigt. Der berechnete
   Wochengesamtpreis (Felder + Zusatzspiele) wird mit der Laufzeit multipliziert. Dies stellt sicher, dass Dauerscheine
   über mehrere Wochen korrekt kalkuliert und vom Spielerkonto abgebucht werden können.

