package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "tickets_lotto")
public class TicketLotto extends AbstractTicket {

    @Column(name = "weeks_duration", nullable = false)
    private Integer weeksDuration;

    @Column(name = "draw_wednesday")
    private boolean wednesday;

    @Column(name = "draw_saturday")
    private boolean saturday;

    // Zusatzspiele
    @Column(name = "spiel77")
    private boolean spiel77;

    @Column(name = "super6")
    private boolean super6;

    @Column(name = "gluecksspirale")
    private boolean gluecksspirale;

    @Column(name = "siegerchance")
    private boolean siegerchance;

    @Column(name = "genau")
    private boolean genau;

    @Column(name = "ds")
    private boolean ds;

    @OneToMany(mappedBy = "lottoTicket", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LottoField> fields;

    // Getter / Setter


    public Integer getWeeksDuration() {
        return weeksDuration;
    }

    public void setWeeksDuration(Integer weeksDuration) {
        this.weeksDuration = weeksDuration;
    }

    public boolean isWednesday() {
        return wednesday;
    }

    public void setWednesday(boolean wednesday) {
        this.wednesday = wednesday;
    }

    public boolean isSaturday() {
        return saturday;
    }

    public void setSaturday(boolean saturday) {
        this.saturday = saturday;
    }

    public boolean isSpiel77() {
        return spiel77;
    }

    public void setSpiel77(boolean spiel77) {
        this.spiel77 = spiel77;
    }

    public boolean isSuper6() {
        return super6;
    }

    public void setSuper6(boolean super6) {
        this.super6 = super6;
    }

    public boolean isGluecksspirale() {
        return gluecksspirale;
    }

    public void setGluecksspirale(boolean gluecksspirale) {
        this.gluecksspirale = gluecksspirale;
    }

    public boolean isSiegerchance() {
        return siegerchance;
    }

    public void setSiegerchance(boolean siegerchance) {
        this.siegerchance = siegerchance;
    }

    public boolean isGenau() {
        return genau;
    }

    public void setGenau(boolean genau) {
        this.genau = genau;
    }

    public boolean isDs() {
        return ds;
    }

    public void setDs(boolean ds) {
        this.ds = ds;
    }

    public List<LottoField> getFields() {
        return fields;
    }

    public void setFields(List<LottoField> fields) {
        this.fields = fields;
    }
}