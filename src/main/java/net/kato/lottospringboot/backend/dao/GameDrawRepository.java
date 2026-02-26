package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.GameDraw;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GameDrawRepository extends JpaRepository<GameDraw, Long> {
    List<GameDraw> findByGameName(String gameName);

    Optional<GameDraw> findByGameNameAndGameDate(String gameName, String gameDate);

    GameDraw findTopByOrderByIdDesc();

    void deleteByGameNameAndGameDate(String gameName, String gameDate);
}
