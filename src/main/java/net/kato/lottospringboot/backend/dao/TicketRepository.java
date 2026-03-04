package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.Ticket;
import net.kato.lottospringboot.backend.model.Player;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long>, JpaSpecificationExecutor<Ticket> {

    List<Ticket> findByPlayer(Player player);

}