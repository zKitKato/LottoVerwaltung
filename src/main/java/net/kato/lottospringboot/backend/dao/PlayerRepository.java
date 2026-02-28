package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.Player;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PlayerRepository extends JpaRepository<Player, Long>, JpaSpecificationExecutor<Player> {

    Optional<Player> findByUsername(String username);

    // Optional: für einfache Keyword-Suche
    List<Player> findByUsernameContainingIgnoreCase(String username);

    Player findTopByOrderByIdDesc();

}