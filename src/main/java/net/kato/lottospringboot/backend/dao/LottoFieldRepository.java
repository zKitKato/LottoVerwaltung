package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.LottoField;
import net.kato.lottospringboot.backend.model.TicketLotto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LottoFieldRepository extends JpaRepository<LottoField, Long> {

    // Korrekt: Feldname in LottoField ist lottoTicket
    List<LottoField> findByLottoTicket(TicketLotto lottoTicket);

    long countByLottoTicket(TicketLotto lottoTicket);
}