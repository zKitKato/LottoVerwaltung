---
id: repositories
title: Repositories (DAO-Schicht)
sidebar_label: Repositories
---

# Repositories als Data Access Objects (DAO)

In der Spring Boot Architektur dienen Repositories als **DAO-Schicht**. Sie kapseln den Zugriff auf die H2-Datenbank.
Durch die Nutzung von **Spring Data JPA** müssen wir keine komplexen SQL-Queries schreiben; stattdessen nutzen wir
Java-Interfaces und JPQL (Java Persistence Query Language).

---

## 1. TicketOverviewRepository – Performance durch JOIN FETCH

Die `TicketOverview` ist eine virtuelle Sicht auf Lotto- und Euro-Tickets. Um das berüchtigte **N+1 Problem** (viele
einzelne Datenbankabfragen für verknüpfte Spieler) zu vermeiden, nutzen wir hier optimierte Abfragen.

### Der Quellcode

```java

@Repository
public interface TicketOverviewRepository extends JpaRepository<TicketOverview, String> {

    // JOIN FETCH sorgt dafür, dass der Player in einer einzigen Abfrage mitgeladen wird
    @Query("SELECT t FROM TicketOverview t JOIN FETCH t.player")
    List<TicketOverview> findAllOptimized(Sort sort);

    // Suche über den Usernamen des verknüpften Players
    @Query("SELECT t FROM TicketOverview t JOIN FETCH t.player " +
            "WHERE LOWER(t.player.username) LIKE LOWER(concat('%', :keyword, '%'))")
    List<TicketOverview> findByUsernameOptimized(@Param("keyword") String keyword, Sort sort);
}
```

Erläuterung:

JOIN FETCH: Normalerweise würde JPA den Spieler erst laden, wenn t.getPlayer() aufgerufen wird (Lazy Loading). Das würde
bei 100 Tickets 100 zusätzliche Datenbankabfragen bedeuten. JOIN FETCH erzwingt ein SQL-Join, sodass alle Daten in einem
Rutsch geladen werden.

LOWER & concat: Ermöglicht eine case-insensitive Suche im Usernamen, unabhängig davon, wie der Name in der H2-Datenbank
gespeichert ist.

---

2. LottoTicketRepository – Spezifische Abfragen
   Dieses Repository verwaltet die physischen Daten der Lotto-Tickets und stellt sicher, dass die Verknüpfung zum
   Besitzer (Player) stabil bleibt.

Der Quellcode

```Java
public interface LottoTicketRepository extends JpaRepository<TicketLotto, Long> {

    // Filtert alle Tickets eines spezifischen Spielers
    @Query("SELECT t FROM TicketLotto t JOIN FETCH t.player WHERE t.player = :player")
    List<TicketLotto> findByPlayer(@Param("player") Player player);

    // Methode für die Dashboard-Ansicht (Top 10)
    @Query("SELECT t FROM TicketLotto t JOIN FETCH t.player")
    List<TicketLotto> findTop10WithPlayer(Pageable pageable);

}
```

Erläuterung:

@Param: Verknüpft die Methode-Parameter sicher mit den Platzhaltern in der @Query.

Pageable: Ermöglicht es dem ViewController, nur eine begrenzte Menge an Daten (z. B. nur die 10 neuesten Tickets)
abzurufen, was den Speicher schont.

--- 

3. GameDrawLottoRepository – Daten-Integrität
   Dieses Repository wird vor allem vom DataImportService genutzt, um die aktuellen Ziehungszahlen aus den JSON-Imports
   zu verwalten.

Der Quellcode

```Java
public interface GameDrawLottoRepository extends JpaRepository<GameDrawLotto, Long> {

    // Wird genutzt, um Dubletten beim Import zu verhindern
    Optional<GameDrawLotto> findByGameDate(String gameDate);

    // Holt die aktuellste Ziehung für die Anzeige auf dem Dashboard
    GameDrawLotto findTopByOrderByIdDesc();

}
```

Erläuterung:

Optional<T>: Ein sauberer Weg, um mit "Null"-Werten umzugehen. Wenn für ein Datum noch keine Ziehung existiert, liefert
die Methode ein leeres Optional statt null, was NullPointerExceptions verhindert.

findTopByOrderByIdDesc(): Eine sogenannte Query Method. Spring JPA versteht den Namen automatisch und generiert ein:
SELECT * FROM game_draw_lotto ORDER BY id DESC LIMIT 1.