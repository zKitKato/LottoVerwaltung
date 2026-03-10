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

### Erweiterte Ticket-Suche & Filterung

* **Zeitraum-Filter**: Implementierung einer Kalender-Auswahl zur präzisen Eingrenzung von Tippscheinen nach
  Ziehungsdatum.
* **Status-Filter**: Einführung von Schnellfiltern für "Offene", "Gewonnene" und "Abgelaufene" Tickets in der Übersicht.
* **Export-Funktion**: Möglichkeit zum Export der gefilterten Ticket-Listen in das CSV- oder PDF-Format für
  buchhalterische Zwecke.

### Verfeinerung der Validierung

* **Dynamische Guthabenprüfung**: Integration einer Echtzeit-Warnung bereits während der Ticketerstellung, falls das
  Guthaben nicht ausreicht.
* **Erweiterte Dublettenprüfung**: Optionale Warnmeldung bei identischen Tipps für verschiedene Ziehungszeiträume.

---

## Phase 2: Automatisierung und Reporting (Mittelfristig)

### Vollautomatisierte Gewinnermittlung

* **Cron-Jobs**: Automatisierung des `./pullLotto.sh` Skripts, um Ziehungsdaten ohne manuelles Eingreifen täglich oder
  wöchentlich zu aktualisieren.
* **Gewinnklassen-Logik**: Erweiterung der Trefferermittlung um die offiziellen Gewinnklassen (Quote) zur Berechnung der
  exakten Gewinnsummen.
* **Benachrichtigungssystem**: Implementierung eines Mail-Services, der Spieler automatisch über Gewinne informiert.

### Dashboard-Statistiken

* **Finanzübersicht**: Visualisierung der Gesamteinsätze vs. Gesamtauszahlungen im Dashboard.
* **Spieler-Analysen**: Grafische Darstellung der aktivsten Spieler und der beliebtesten Lotterie-Typen.

---

## Phase 3: Systemerweiterung und Sicherheit (Langfristig)

### Erweiterung der Lotterie-Typen

* **Zusatzlotterien**: Integration von Spiel 77 und Super 6 in die Ticket-Verwaltung und Gewinnprüfung.
* **Systemscheine**: Unterstützung für Voll- und Teilsystemscheine bei Lotto 6aus49 und Eurojackpot.

### Architektur und Sicherheit

* **Rollenbasiertes Rechtesystem (RBAC)**: Differenzierung zwischen Administratoren (Vollzugriff) und Standard-Nutzern (
  nur eigene Tickets/Profil).
* **API-Dokumentation**: Vollständige Bereitstellung einer Swagger/OpenAPI-Dokumentation für die Backend-Endpunkte.
* **Datenbank-Migration**: Optionale Unterstützung für PostgreSQL oder MySQL als Alternative zur embedded H2-Datenbank
  für den produktiven Einsatz.

---

## Status der aktuellen Version (v0.0.4-alpha)

* [x] Grundlegende Spieler- und Ticketverwaltung.
* [ ] Manuelle Gewinnermittlung via Skript-Trigger.
* [ ] Basis-Validierung (Guthaben & Dubletten).
* [ ] Automatisierte Benachrichtigungen (Geplant für Phase 2).