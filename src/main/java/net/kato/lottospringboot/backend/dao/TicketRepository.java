package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.Ticket;
import net.kato.lottospringboot.backend.model.Player;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long> {

    // Finde alle Tickets eines bestimmten Spielers
    List<Ticket> findByPlayer(Player player);

    // Optional: Tickets nach Spielart filtern
    List<Ticket> findByGameType(String gameType);

    // Optional: Tickets nach Spieler und Spielart filtern
    List<Ticket> findByPlayerAndGameType(Player player, String gameType);
}