package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.GameDrawLotto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GameDrawLottoRepository extends JpaRepository<GameDrawLotto, Long> {

    Optional<GameDrawLotto> findByGameDate(String gameDate);

    GameDrawLotto findTopByOrderByIdDesc();

}