package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.Player;
import net.kato.lottospringboot.backend.model.TicketEuro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.awt.print.Pageable;
import java.util.List;

public interface EuroTicketRepository extends JpaRepository<TicketEuro, Long> {
    @Query("SELECT t FROM TicketEuro t JOIN FETCH t.player WHERE t.player = :player")
    List<TicketEuro> findByPlayer(@Param("player") Player player);

    @Query("SELECT t FROM TicketEuro t JOIN FETCH t.player")
    List<TicketEuro> findTop10WithPlayer(Pageable pageable);
}