package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*;

@Entity
@Table(name = "fields")
public class Field {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ticket_id", nullable = false)
    private Ticket ticket;

    @Column(name = "numbers", nullable = false)
    private String numbers; // z.B. "5,8,20,33,49,12"

    @Column(name = "extra_number")
    private String extraNumber; // Superzahl oder Eurozahlen

    // Getter / Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    public String getNumbers() {
        return numbers;
    }

    public void setNumbers(String numbers) {
        this.numbers = numbers;
    }

    public String getExtraNumber() {
        return extraNumber;
    }

    public void setExtraNumber(String extraNumber) {
        this.extraNumber = extraNumber;
    }
}