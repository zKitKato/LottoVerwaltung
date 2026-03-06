package net.kato.lottospringboot.backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "euro_fields")
public class EuroField {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ticket_id")
    @JsonIgnore
    private TicketEuro euroTicket;

    @Column(nullable = false)
    private String numbers;
    // "1,5,12,23,34"

    @Column(nullable = false)
    private String euroNumbers;
    // "3,11"

    // Getter / Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public TicketEuro getEuroTicket() {
        return euroTicket;
    }

    public void setEuroTicket(TicketEuro euroTicket) {
        this.euroTicket = euroTicket;
    }

    public String getNumbers() {
        return numbers;
    }

    public void setNumbers(String numbers) {
        this.numbers = numbers;
    }

    public String getEuroNumbers() {
        return euroNumbers;
    }

    public void setEuroNumbers(String euroNumbers) {
        this.euroNumbers = euroNumbers;
    }


}


