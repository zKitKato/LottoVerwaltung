---
id: usermanual
title: Benutzerhandbuch
sidebar_label: App-Starten
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Bedienung

Dieses Handbuch führt Sie durch die Funktionen der Lotto-Verwaltungs-Applikation.

---

## App-Start und Container-Verwaltung

Die Anwendung wird mittels Docker bereitgestellt. Je nach Anforderungen können Sie verschiedene Befehle für den Betrieb
der Container nutzen.

<Tabs>
  <TabItem value="start" label="Standard Start" default>
    <p>Nutzen Sie diesen Befehl, um die Container im Vordergrund zu starten:</p>
    ```bash
    docker compose up
    ```
  </TabItem>
  <TabItem value="build" label="Neu bauen">
    <p>Verwenden Sie diesen Befehl, wenn Sie Änderungen an den Bibliotheken oder dem Dockerfile vorgenommen haben:</p>
    ```bash
    docker compose up --build
    ```
    * **--build**: Erzwingt das Neuerstellen der Images. Dies ist notwendig, wenn Abhängigkeiten in den Bibliotheken
  aktualisiert wurden oder die Konfiguration von Grund auf neu geladen werden muss.
  </TabItem>
  <TabItem value="background" label="Hintergrund">
    <p>Um die Container im Hintergrund zu starten, nutzen Sie den Detached-Modus:</p>
    ```bash
    docker compose up -d
    ```
    * **-d (detached)**: Dieser Parameter startet die Container im Hintergrund. Ihre Konsole bleibt für weitere Eingaben
  frei, während die Applikation läuft.
  </TabItem>
  <TabItem value="stop" label="Stoppen">
    <p>Um die Container sicher herunterzufahren:</p>
    ```bash
    docker compose down
    ```
  </TabItem>
  <TabItem value="clean" label="Daten löschen">
    <p>Um die Container zu stoppen und gleichzeitig alle zugehörigen Volumes zu entfernen:</p>
    ```bash
    docker compose down -v
    ```
    * **-v (volumes)**: Löscht die mit den Containern verknüpften Volumes beim Herunterfahren. Dies dient der Bereinigung
  des Systems. **Wichtig:** Die primären Daten in der Datenbank bleiben bei einer Standard-Konfiguration dennoch
  erhalten, sofern diese über externe Pfade gesichert sind.
  </TabItem>
</Tabs>


---

## Datenaktualisierung

Um die aktuellsten Lottozahlen in das System zu laden, führen Sie bitte das bereitgestellte Skript im Hauptverzeichnis
aus:

```bash
./pullLotto.sh