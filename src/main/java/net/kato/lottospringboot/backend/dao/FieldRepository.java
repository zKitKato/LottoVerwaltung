package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.Field;
import net.kato.lottospringboot.backend.model.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FieldRepository extends JpaRepository<Field, Long> {

    // Alle Felder zu einem bestimmten Ticket abrufen
    List<Field> findByTicket(Ticket ticket);

    // Optional: ein Feld nach ID und Ticket abrufen (z.B. für Validierung)
    Optional<Field> findByIdAndTicket(Long id, Ticket ticket);
}