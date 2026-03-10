---
id: datenfluss
title: Datenfluss & Schichtenmodell
sidebar_label: Datenfluss
---

# Datenfluss: Vom Browser zur Datenbank

Um zu verstehen, wie die Lotto-Applikation arbeitet, hilft ein Blick auf den Weg, den eine Anfrage (z. B. "Ticket
speichern") durch die verschiedenen Schichten nimmt.

## Architektur-Diagramm

Hier ist der Prozess vereinfacht dargestellt:

```mermaid
graph TD
    A[Browser / User] -->|1. HTTP POST /ticket/add| B(ViewController)
    B -->|2. Validierung & Daten-Parsing| B
    B -->|3. Preis anfordern| C(TicketPriceService)
    C -->|4. BigDecimal Ergebnis| B
    B -->|5. Objekt speichern| D(Repositories / DAO)
    D -->|6. SQL INSERT| E[(H2 Database)]
    E -->|7. Bestätigung| D
    D -->|8. Entity zurück| B
    B -->|9. Redirect / Success| A
```