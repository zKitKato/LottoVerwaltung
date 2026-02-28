package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "tickets")
public class Ticket {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Beziehung zum Spieler
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player_id", nullable = false)
    private Player player;

    @Column(name = "game_type", nullable = false)
    private String gameType; // z.B. "Lotto" oder "Eurojackpot"

    @Column(name = "numbers", columnDefinition = "TEXT", nullable = false)
    private String numbers; // z.B. "3,7,12,15,22,34"

    @Column(name = "extra_numbers", columnDefinition = "TEXT")
    private String extraNumbers; // optional

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

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

    public String getGameType() {
        return gameType;
    }

    public void setGameType(String gameType) {
        this.gameType = gameType;
    }

    public String getNumbers() {
        return numbers;
    }

    public void setNumbers(String numbers) {
        this.numbers = numbers;
    }

    public String getExtraNumbers() {
        return extraNumbers;
    }

    public void setExtraNumbers(String extraNumbers) {
        this.extraNumbers = extraNumbers;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
