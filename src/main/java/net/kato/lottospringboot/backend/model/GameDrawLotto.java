package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*;

import java.math.BigDecimal;

@Entity
@Table(name = "lotto_draws",
        uniqueConstraints = @UniqueConstraint(columnNames = "game_date"))
public class GameDrawLotto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "game_date")
    private String gameDate;

    @Column(name = "draw_day")
    private String drawDay;

    @Column(columnDefinition = "TEXT")
    private String numbers;

    @Column(columnDefinition = "TEXT")
    private String extraNumbers;

    private BigDecimal jackpot;

    private String nextDeadlineDate;
    private String nextDeadlineTime;

    // Getter / Setter

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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