---
id: roadmap
title: Projekt-Roadmap
sidebar_label: Roadmap
---

# Strategische Roadmap

Diese Roadmap beschreibt die geplanten Erweiterungen und Optimierungen der Lotto-Verwaltungs-Applikation. Die
Priorisierung erfolgt auf Basis der funktionalen Relevanz für den stabilen Betrieb und die Benutzerfreundlichkeit.

---

## Phase 1: Optimierung der Kernfunktionen (Kurzfristig)

### Finanz-Logik & Kontostand-Management

* **Automatisierte Verrechnung**: Direkte Kopplung der Ticket-Erstellung mit dem Spielerkonto. Bei Kauf eines Tickets
  wird der `totalPrice` automatisch vom `kontostand` des Spielers abgezogen.
* **Liquiditäts-Alerts**: Implementierung eines visuellen Warnsystems (Alerts) im Dashboard und in der Spieler-Tabelle,
  sobald ein Kontostand ins Minus rutscht oder ein definiertes Limit unterschreitet.
* **Transaktions-Historie**: Protokollierung jeder Kontobewegung (Einzahlung, Ticketkauf, Gewinn) für eine lückenlose
  Nachverfolgbarkeit.

### Erweiterte Ticket-Suche & Filterung

* **Zeitraum-Filter**: Implementierung einer Kalender-Auswahl zur präzisen Eingrenzung von Tippscheinen nach
  Ziehungsdatum.
* **Export-Funktion**: Möglichkeit zum Export der gefilterten Listen in das CSV- oder PDF-Format für buchhalterische
  Zwecke.

---

## Phase 2: Automatisierung und Reporting (Mittelfristig)

### Gewinnermittlung & Finanz-Reporting

* **Vollautomatisierte Gewinnprüfung**: Kopplung der Ziehungsdaten mit den abgegebenen Tipps zur automatischen
  Identifizierung von Gewinnern.
* **Gewinn-Verlust-Rechnung (G&V)**: Einführung eines Reporting-Moduls, das die Einsätze den Gewinnen gegenüberstellt (
  auf Spieler-Ebene und für das Gesamtsystem).
* **Cron-Jobs**: Automatisierung des `./pullLotto.sh` Skripts für tägliche Daten-Updates ohne manuellen Eingriff.

### Dashboard-Statistiken

* **Finanz-Visualisierung**: Grafische Darstellung der Cashflow-Entwicklung (Einsätze vs. Auszahlungen).
* **Benachrichtigungssystem**: Automatisierter Mail-Versand bei Gewinnbenachrichtigungen oder kritischem Kontostand.

---

## Phase 3: Systemerweiterung und Sicherheit (Langfristig)

### Erweiterung der Lotterie-Typen

* **Zusatzlotterien & Systemscheine**: Vollständige Integration von Spiel 77, Super 6 sowie Unterstützung für Voll- und
  Teilsystemscheine.
* **Rollenbasiertes Rechtesystem (RBAC)**: Einführung von Nutzerrollen (Admin vs. Standard-User) zur Absicherung
  sensibler Finanzdaten.

### Architektur-Upgrades

* **Datenbank-Migration**: Unterstützung für PostgreSQL oder MySQL für den produktiven Einsatz außerhalb der
  H2-Umgebung.
* **API-Dokumentation**: Bereitstellung einer Swagger/OpenAPI-Schnittstelle für externe Integrationen.

---

## Status der aktuellen Version (v0.0.4-alpha)

* [x] Grundlegende Spieler- und Ticketverwaltung.
* [x] Basis-Layout und Navigationsstruktur.
* [ ] Automatisierte Kontostands-Verrechnung (In Arbeit).
* [ ] Gewinn-Verlust-Reporting (Geplant für Phase 2).
* [ ] Minus-Alerts für Spieler (Geplant für Phase 1).