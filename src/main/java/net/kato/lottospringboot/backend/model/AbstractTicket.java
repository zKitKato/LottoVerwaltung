package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@MappedSuperclass
public abstract class AbstractTicket {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    protected Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player_id", nullable = false)
    protected Player player;

    @Column(name = "losnummer", nullable = false, length = 20)
    protected String losnummer;
    // letzte Stelle = Superzahl bei Lotto

    @Column(name = "valid_from", nullable = false)
    protected LocalDate validFrom;

    @Column(name = "valid_until")
    protected LocalDate validUntil;

    @Column(name = "draw_count")
    protected Integer drawCount;
    // Anzahl Ziehungen (Eurojackpot wichtig)

    @Column(name = "created_at", nullable = false)
    protected LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "total_price", nullable = false)
    protected BigDecimal totalPrice = BigDecimal.ZERO;

    // Getter / Setter


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Player getPlayer() {
        return player;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }

    public LocalDate getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(LocalDate validFrom) {
        this.validFrom = validFrom;
    }

    public LocalDate getValidUntil() {
        return validUntil;
    }

    public void setValidUntil(LocalDate validUntil) {
        this.validUntil = validUntil;
    }

    public String getLosnummer() {
        return losnummer;
    }

    public void setLosnummer(String losnummer) {
        this.losnummer = losnummer;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getDrawCount() {
        return drawCount;
    }

    public void setDrawCount(Integer drawCount) {
        this.drawCount = drawCount;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}