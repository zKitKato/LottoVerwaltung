---
id: ziehungen
title: Ziehungen und Ergebnisse
sidebar_label: Ziehungen
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ziehungen und Ergebnisse

In diesem Modul werden die historischen und aktuellen Ziehungsdaten verwaltet. Diese Daten bilden die Grundlage für die
automatische Gewinnermittlung der im System hinterlegten Tickets.

---

## Übersicht der Ziehungsdaten

Über die Sidebar haben Sie direkten Zugriff auf die spezifischen Add-ons für die jeweiligen Lotterien. Das System
unterscheidet hierbei strikt zwischen den verschiedenen Spielarten:

<Tabs>
  <TabItem value="lotto-draw" label="Lotto 6aus49" default>
    <p>Hier finden Sie die Gewinnzahlen der klassischen 6aus49 Ziehungen inklusive der Superzahl.</p>

    ![Lotto Ziehungen](/img/LottoZiehungen.png)

  </TabItem>
  <TabItem value="euro-draw" label="Eurojackpot">
    <p>Diese Ansicht zeigt die gezogenen Zahlen sowie die Eurozahlen des Eurojackpots.</p>

    ![Eurojackpot Ziehungen](/img/EuroZiehungen.png)

  </TabItem>
</Tabs>

---

## Manuelle Aktualisierung

Wie bereits im Abschnitt **Installation & Setup** erwähnt, können die aktuellsten Ziehungszahlen jederzeit manuell
angefordert werden. Führen Sie dazu im Hauptverzeichnis der Anwendung folgenden Befehl aus:

```bash
./pullLotto.sh