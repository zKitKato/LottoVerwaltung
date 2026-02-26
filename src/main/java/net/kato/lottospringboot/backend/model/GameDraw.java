package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*;

import java.math.BigDecimal;

@Entity
@Table(name = "game_draws")
public class GameDraw {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "game_name")
    private String gameName;

    @Column(name = "game_date")
    private String gameDate;

    @Column(name = "draw_day")
    private String drawDay;

    // ✅ EINFACH: JSON-String statt List
    @Column(name = "numbers", columnDefinition = "TEXT")
    private String numbers;  // "[25,9,13,37,46,30]"

    @Column(name = "extra_numbers", columnDefinition = "TEXT")
    private String extraNumbers;  // "[8]" oder "[9,2]"

    @Column(name = "jackpot")
    private BigDecimal jackpot;

    @Column(name = "next_deadline_date")
    private String nextDeadlineDate;

    @Column(name = "next_deadline_time")
    private String nextDeadlineTime;

    // Default Constructor
    public GameDraw() {
    }

    // Getter und Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    public String getGameDate() {
        return gameDate;
    }

    public void setGameDate(String gameDate) {
        this.gameDate = gameDate;
    }

    public String getDrawDay() {
        return drawDay;
    }

    public void setDrawDay(String drawDay) {
        this.drawDay = drawDay;
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

    public BigDecimal getJackpot() {
        return jackpot;
    }

    public void setJackpot(BigDecimal jackpot) {
        this.jackpot = jackpot;
    }

    public String getNextDeadlineDate() {
        return nextDeadlineDate;
    }

    public void setNextDeadlineDate(String nextDeadlineDate) {
        this.nextDeadlineDate = nextDeadlineDate;
    }

    public String getNextDeadlineTime() {
        return nextDeadlineTime;
    }

    public void setNextDeadlineTime(String nextDeadlineTime) {
        this.nextDeadlineTime = nextDeadlineTime;
    }
}
