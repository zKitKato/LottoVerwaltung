package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.TicketOverview;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TicketOverviewRepository extends JpaRepository<TicketOverview, String> {
    // JOIN FETCH für den Player, damit der Username sofort da ist
    @Query("SELECT t FROM TicketOverview t JOIN FETCH t.player")
    List<TicketOverview> findAllOptimized(Sort sort);

    @Query("SELECT t FROM TicketOverview t JOIN FETCH t.player WHERE LOWER(t.player.username) LIKE LOWER(concat('%', :keyword, '%'))")
    List<TicketOverview> findByUsernameOptimized(@Param("keyword") String keyword, Sort sort);
}