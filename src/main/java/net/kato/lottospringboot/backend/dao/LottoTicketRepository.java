package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.Player;
import net.kato.lottospringboot.backend.model.TicketLotto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.awt.print.Pageable;
import java.util.List;

public interface LottoTicketRepository extends JpaRepository<TicketLotto, Long> {
    @Query("SELECT t FROM TicketLotto t JOIN FETCH t.player WHERE t.player = :player")
    List<TicketLotto> findByPlayer(@Param("player") Player player);

    // Wir brauchen eine Methode für die "Top 10" mit geladenem Spieler
    @Query("SELECT t FROM TicketLotto t JOIN FETCH t.player")
    List<TicketLotto> findTop10WithPlayer(Pageable pageable);
}