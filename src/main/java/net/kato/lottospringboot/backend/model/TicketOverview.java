package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*;
import org.hibernate.annotations.Immutable;
import org.hibernate.annotations.Subselect;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Immutable
@Subselect("""
        SELECT 
            CONCAT(game_type, '_', id) as composite_id,
            id as original_id,
            player_id,
            losnummer,
            valid_from,
            valid_until,
            total_price,
            created_at,
            game_type,
            spiel77,
            super6,
            gluecksspirale,
            CASE 
                WHEN game_type = 'LOTTO' THEN (SELECT COUNT(*) FROM lotto_fields lf WHERE lf.ticket_id = t.id)
                WHEN game_type = 'EURO' THEN (SELECT COUNT(*) FROM euro_fields ef WHERE ef.ticket_id = t.id)
                ELSE 0 
            END as field_count
        FROM (
            SELECT id, player_id, losnummer, valid_from, valid_until, total_price, created_at, 'LOTTO' as game_type, spiel77, super6, gluecksspirale FROM tickets_lotto
            UNION ALL
            SELECT id, player_id, losnummer, valid_from, valid_until, total_price, created_at, 'EURO' as game_type, spiel77, super6, gluecksspirale FROM tickets_euro
        ) t
        """)
public class TicketOverview {
    @Id
    @Column(name = "composite_id")
    private String compositeId;

    @Column(name = "original_id")
    private Long id;

    @Column(name = "player_id")
    private Long playerId;

    private String losnummer;
    private LocalDate validFrom;
    private LocalDate validUntil;
    private BigDecimal totalPrice;
    private LocalDateTime createdAt;
    private String gameType;
    private boolean spiel77;
    private boolean super6;
    private boolean gluecksspirale;
    private int fieldCount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player_id", insertable = false, updatable = false)
    private Player player;

    // Getter (Wichtig für JSP!)
    public String getCompositeId() {
        return compositeId;
    }

    public Long getId() {
        return id;
    }

    public Long getPlayerId() {
        return playerId;
    }

    public String getLosnummer() {
        return losnummer;
    }

    public LocalDate getValidFrom() {
        return validFrom;
    }

    public LocalDate getValidUntil() {
        return validUntil;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public String getGameType() {
        return gameType;
    }

    public boolean isSpiel77() {
        return spiel77;
    }

    public boolean isSuper6() {
        return super6;
    }

    public boolean isGluecksspirale() {
        return gluecksspirale;
    }

    public int getFieldCount() {
        return fieldCount;
    }

    public Player getPlayer() {
        return player;
    }
}