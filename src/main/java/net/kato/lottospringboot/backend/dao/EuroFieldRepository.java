package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.EuroField;
import net.kato.lottospringboot.backend.model.TicketEuro;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EuroFieldRepository extends JpaRepository<EuroField, Long> {

    // Korrekt: Feldname in EuroField ist euroTicket
    List<EuroField> findByEuroTicket(TicketEuro euroTicket);

    long countByEuroTicket(TicketEuro euroTicket);
}