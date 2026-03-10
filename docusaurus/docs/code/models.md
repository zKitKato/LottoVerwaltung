---
id: models
title: Datenmodelle & Datenbankstruktur
sidebar_label: Models
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Datenmodelle (Entities)

Die Applikation nutzt **Jakarta Persistence (JPA)**, um Java-Objekte auf Tabellen in der **H2-Datenbank** abzubilden. Da
H2 eine relationale Datenbank ist, werden Verknüpfungen (Relationships) genutzt, um Spieler, Tickets und Spielfelder
konsistent zu verwalten.

---

## Authentifizierung: User

Die `User`-Klasse repräsentiert die administrativen Zugänge für das Backend.

* **Sicherheit**: Der `username` ist eindeutig (`unique`) und das Passwort wird verschlüsselt gespeichert.
* **Datenbank**: Die Tabelle wird in H2 als `users` angelegt.

```java

@Entity
@Table(name = "users", uniqueConstraints = @UniqueConstraint(columnNames = "username"))
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    // Default Constructor (für JPA erforderlich)
    public User() {
    }

    // Konstruktor mit Username/Password
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }
}
```

---

## Teilnehmer-Verwaltung: Player

Ein `Player` stellt einen aktiven Teilnehmer am Lottosystem dar.

Finanzen: Das Feld `kontostand` verwendet `BigDecimal`, um Rundungsfehler bei Geldbeträgen in der Datenbank zu
vermeiden.

Verknüpfung: Ein Spieler kann viele Tickets besitzen (`@OneToMany`).

```java 

@Entity
@Table(name = "players", uniqueConstraints = @UniqueConstraint(columnNames = "username"))
public class Player {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    private LocalDate spieltMitSeit;
    private String spiele; // z.B. "Lotto, Eurojackpot"
    private BigDecimal kontostand;
    private String status;

    @OneToMany(mappedBy = "player", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<TicketOverview> tickets;
}
```

Ticket-System & Vererbung
Um Code-Duplikate zu vermeiden, nutzt die Applikation eine abstrakte Basisklasse.

AbstractTicket (Vererbung)
Die Klasse `AbstractTicket` ist als `@MappedSuperclass` definiert. Das bedeutet, dass sie selbst keine eigene Tabelle in
der
H2-Datenbank hat, aber ihre Felder (wie `losnummer`, `validFrom`, `totalPrice`) an die Unterklassen vererbt. So wird
sichergestellt, dass jedes Ticket, egal welcher Art, über die gleichen Grunddaten verfügt.

Ticket-Typen im Vergleich
Hier sehen Sie die spezifischen Implementierungen für die verschiedenen Lotterien:

<Tabs>
<TabItem value="lotto" label="TicketLotto" default>

```Java

@Entity
@Table(name = "tickets_lotto")
public class TicketLotto extends AbstractTicket {
    private Integer weeksDuration;
    private boolean wednesday;
    private boolean saturday;

    // Zusatzspiele
    private boolean spiel77;
    private boolean super6;
    private boolean gluecksspirale;

    @OneToMany(mappedBy = "lottoTicket", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LottoField> fields;
}
```

</TabItem>
<TabItem value="euro" label="TicketEuro">

```Java

@Entity
@Table(name = "tickets_euro")
public class TicketEuro extends AbstractTicket {
    // Zusatzspiele
    private boolean spiel77;
    private boolean super6;
    private boolean gluecksspirale;

    @OneToMany(mappedBy = "euroTicket", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<EuroField> fields;
}
```

</TabItem>
</Tabs>

---

## Spielfelder (Fields)

Da ein Ticket mehrere Tippfelder enthalten kann (z.B. 12 Felder auf einem Lottoschein), sind diese in eigenen Tabellen
ausgelagert.

Zusammenhang: Ein `LottoField` gehört immer zu genau einem TicketLotto (`@ManyToOne`).

Daten: Die gewählten Zahlen werden als String gespeichert (kommagetrennt), um die Flexibilität in der H2-Datenbank zu
erhöhen.


---

## Spezialfall: TicketOverview

Die `TicketOverview` ist eine Besonderheit. Sie nutzt das `@Subselect`-Annotation von Hibernate.

Warum? Anstatt zwei getrennte Listen für Lotto- und Euro-Tickets in der UI anzuzeigen, führt dieses Model beide
Tabellen (`tickets_lotto` und `tickets_euro`) mittels eines SQL-UNION ALL virtuell zusammen.

Eigenschaft: Sie ist `@Immutable` (schreibgeschützt) und dient rein der performanten Anzeige in der Ticket-Tabelle.