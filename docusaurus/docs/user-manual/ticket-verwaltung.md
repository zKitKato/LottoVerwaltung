---
id: ticket-verwaltung
title: Ticket-Verwaltung
sidebar_label: Ticket-Verwaltung
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Ticket-Verwaltung

In diesem Modul werden sämtliche Tippscheine (Tickets) der Teilnehmer verwaltet. Sie können hier bestehende Tickets
einsehen, nach spezifischen Kriterien filtern und neue Spielscheine für unterschiedliche Lotterien anlegen.

---

## Ticketübersicht und Suche

Die Ticketübersicht bietet eine tabellarische Auflistung aller im System registrierten Tippscheine. Hier erhalten Sie
Informationen über den Status, die gewählten Zahlen und die zugehörigen Spieler.

![Ticketübersicht](/img/TicketUebersicht.png)

### Navigation zum Spielerprofil

Um die Verwaltung zu vereinfachen, ist die Ticket-Tabelle direkt mit der Spieler-Verwaltung verknüpft:

* **Direktzugriff**: Durch einen Klick auf den **Usernamen** innerhalb der Ticket-Tabelle gelangen Sie unmittelbar zum
  detaillierten **Spielerprofil** des entsprechenden Teilnehmers. Dies ermöglicht eine schnelle Überprüfung des
  Kontostands oder der Gewinnstatistik, ohne das Modul manuell wechseln zu müssen.

### Suchfunktion für Tickets

Um die Vielzahl der Datensätze effizient zu verwalten, steht Ihnen eine Suchmaske zur Verfügung.

![Ticketsuche](/img/TicketSuche.png)


---

## Tickets anlegen

Beim Anlegen eines neuen Tickets unterscheidet das System zwischen verschiedenen Lotterie-Typen. Um die
Übersichtlichkeit zu wahren, wählen Sie bitte den entsprechenden Reiter für die jeweilige Lotterie aus:

<Tabs>
  <TabItem value="lotto" label="Lotto 6aus49" default>
    <p>Nutzen Sie diese Maske, um einen Standard-Lottoschein zu registrieren.</p>

    ![Ticket anlegen Lotto](/img/TicketAnlegenLotto.png)
    
    * **Vorgehensweise**: Wählen Sie den Spieler aus und geben Sie die getippten Zahlen sowie die Superzahl ein. Nach der Validierung durch das System kann der Schein gespeichert werden.

  </TabItem>
  <TabItem value="euro" label="Eurojackpot">
    <p>Diese Maske dient der Erfassung von Eurojackpot-Spielscheinen.</p>

    ![Ticket anlegen Eurojackpot](/img/TicketAnlegenEurojackpot.png)
    
    * **Vorgehensweise**: Zusätzlich zu den Hauptzahlen werden hier die spezifischen Eurozahlen erfasst. Das System prüft dabei automatisch auf die Einhaltung der lotteriespezifischen Regeln.

  </TabItem>
</Tabs>

---

## Tickets bearbeiten

Sollten Korrekturen an bereits erfassten Tippscheinen notwendig sein, bietet das System eine dedizierte
Bearbeitungsmaske. Diese erreichen Sie in der Regel über die Ticketübersicht.

<Tabs>
  <TabItem value="edit-lotto" label="Lotto 6aus49 bearbeiten" default>
    <p>In dieser Ansicht können Sie die Zahlen sowie die Superzahl eines bestehenden Lotto-Tickets korrigieren.</p>

    ![Ticket bearbeiten Lotto](/img/TicketBearbeitenLotto.png)

  </TabItem>
  <TabItem value="edit-euro" label="Eurojackpot bearbeiten">
    <p>Nutzen Sie diese Maske, um die Hauptzahlen oder die Eurozahlen eines Eurojackpot-Tickets anzupassen.</p>

    ![Ticket bearbeiten Eurojackpot](/img/TicketBearbeitenEuro.png)

  </TabItem>
</Tabs>
