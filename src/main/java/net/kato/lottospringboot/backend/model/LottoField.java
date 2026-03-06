package net.kato.lottospringboot.backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "lotto_fields")
public class LottoField {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "ticket_id")
    private TicketLotto lottoTicket;

    @Column(nullable = false)
    private String numbers;
    // "1,5,12,23,34,45"

    @Column(nullable = false)
    private Integer superNumber;
    // 1-12

    // Getter / Setter

    public TicketLotto getLottoTicket() {
        return lottoTicket;
    }

    public void setLottoTicket(TicketLotto lottoTicket) {
        this.lottoTicket = lottoTicket;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNumbers() {
        return numbers;
    }

    public void setNumbers(String numbers) {
        this.numbers = numbers;
    }

    public Integer getSuperNumber() {
        return superNumber;
    }

    public void setSuperNumber(Integer superNumber) {
        this.superNumber = superNumber;
    }
}