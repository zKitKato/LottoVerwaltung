package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "players",
        uniqueConstraints = @UniqueConstraint(columnNames = "username"))
public class Player {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(name = "spielt_mit_seit")
    private LocalDate spieltMitSeit; // optional

    @Column(nullable = false)
    private String spiele; // z.B. "Lotto", "Eurojackpot" oder "Lotto,Eurojackpot"

    @Column(precision = 10, scale = 2)
    private BigDecimal kontostand; // kann negativ sein

    @Column(nullable = false)
    private String status; // z.B. "aktiv", "pausiert", "verlassen"

    // Getter / Setter

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public LocalDate getSpieltMitSeit() {
        return spieltMitSeit;
    }

    public void setSpieltMitSeit(LocalDate spieltMitSeit) {
        this.spieltMitSeit = spieltMitSeit;
    }

    public String getSpiele() {
        return spiele;
    }

    public void setSpiele(String spiele) {
        this.spiele = spiele;
    }

    public BigDecimal getKontostand() {
        return kontostand;
    }

    public void setKontostand(BigDecimal kontostand) {
        this.kontostand = kontostand;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
