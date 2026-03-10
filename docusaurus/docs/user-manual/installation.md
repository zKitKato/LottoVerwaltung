---
id: installation
title: Installation und Setup
sidebar_label: Installation
---

# Installation und Projekt-Setup

Diese Anleitung beschreibt die notwendigen Schritte, um das Projekt lokal aufzusetzen und die erforderlichen
Sicherheitskonfigurationen vorzunehmen.

---

## Projekt beziehen

Sie können die aktuelle Version des Projekts entweder direkt über die Kommandozeile laden oder manuell von der
GitHub-Release-Seite beziehen.

### Download via Kommandozeile

Um die Version `v0.0.4-alpha` direkt herunterzuladen, nutzen Sie bitte einen der folgenden Befehle:

**Verwendung von wget:**

```bash
wget [https://github.com/zKitKato/LottoVerwaltung/archive/refs/tags/v0.0.4-alpha.zip](https://github.com/zKitKato/LottoVerwaltung/archive/refs/tags/v0.0.4-alpha.zip)
```

**Verwendung von curl:**

```bash
curl -L -o v0.0.4-alpha.zip [https://github.com/zKitKato/LottoVerwaltung/archive/refs/tags/v0.0.4-alpha.zip](https://github.com/zKitKato/LottoVerwaltung/archive/refs/tags/v0.0.4-alpha.zip)
```

**Manueller Download (Latest Release)**

Alternativ können Sie die [GitHub Release Seite](https://github.com/zKitKato/LottoVerwaltung/releases) besuchen, um die
aktuellste Version (latest) manuell zu beziehen. Dort
stehen Ihnen folgende Formate zur Verfügung:

- .zip Archiv: Komprimiertes Format, primär für Windows-Umgebungen empfohlen.

- .tar.gz Archiv: Komprimiertes Format, primär für Linux- und macOS-Umgebungen empfohlen.

Nach dem Download müssen Sie das Archiv entpacken und in das entstandene Verzeichnis navigieren, um mit der
Konfiguration fortzufahren.

---

## Konfiguration der Passwörter und Sicherheit

Die Anwendung nutzt zentrale Konfigurationsdateien zur Steuerung der Datenbankzugriffe. Vor dem ersten Start müssen die
Platzhalter für Passwörter durch individuelle, sichere Zeichenfolgen ersetzt werden.

1. Anpassung der .env Datei
   Im Hauptverzeichnis finden Sie die Datei `.env`. Diese Datei dient als zentrale Stelle für Docker- und Spring
   Boot-Umgebungsvariablen. Ändern Sie hier insbesondere die Zugangsdaten für die H2-Datenbank:

Code-Snippet

```
# H2 Database (embedded)

SPRING_DATASOURCE_USERNAME=setup_a_strong_passwrd
SPRING_DATASOURCE_PASSWORD=setup_a_strong_passwrd
```

2. Anpassung der application.properties
   Zusätzlich müssen die Werte in der Datei `src/main/resources/application.properties` mit den Angaben aus der
   .env-Datei
   übereinstimmen, um eine erfolgreiche Verbindung zur Datenbank herzustellen:

Properties

``` 
# Datenbank-Zugriffsparameter

spring.datasource.username=setup_a_strong_passwrd
spring.datasource.password=setup_a_strong_passwrd
```

:::warning Sicherheitshinweis

Achten Sie darauf, dass der Wert
`spring.h2.console.settings.web-allow-others=true`
in einer produktiven Umgebung
kritisch zu hinterfragen ist. Diese Einstellung ermöglicht den Zugriff auf die Datenbankkonsole über das Netzwerk und
kann bei unzureichender Absicherung ein Sicherheitsrisiko darstellen.

:::

