package net.kato.lottospringboot.backend.service;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;


@Service
public class TicketPriceService {

    private static final BigDecimal LOTTO_FIELD_PRICE = BigDecimal.valueOf(1.20);
    private static final BigDecimal EURO_FIELD_PRICE = BigDecimal.valueOf(2.00);

    private static final BigDecimal SPIEL77 = BigDecimal.valueOf(2.50);
    private static final BigDecimal SUPER6 = BigDecimal.valueOf(1.25);
    private static final BigDecimal GLUECK = BigDecimal.valueOf(5.00);

    // ======================
    // LOTTO
    // ======================

    public BigDecimal calcLottoPrice(
            int fieldCount,
            boolean mi,
            boolean sa,
            int weeks,
            boolean spiel77,
            boolean super6,
            boolean glueck
    ) {

        int drawsPerWeek = 0;
        if (mi) drawsPerWeek++;
        if (sa) drawsPerWeek++;

        BigDecimal fieldPricePerWeek =
                LOTTO_FIELD_PRICE
                        .multiply(BigDecimal.valueOf(drawsPerWeek))
                        .multiply(BigDecimal.valueOf(fieldCount));

        BigDecimal extraPerDraw = BigDecimal.ZERO;

        if (spiel77) extraPerDraw = extraPerDraw.add(SPIEL77);
        if (super6) extraPerDraw = extraPerDraw.add(SUPER6);
        if (glueck) extraPerDraw = extraPerDraw.add(GLUECK);

        BigDecimal extraTotal =
                extraPerDraw.multiply(BigDecimal.valueOf(drawsPerWeek));

        BigDecimal weeklyTotal = fieldPricePerWeek.add(extraTotal);

        return weeklyTotal.multiply(BigDecimal.valueOf(weeks));
    }

    // ======================
    // EURO
    // ======================

    public BigDecimal calcEuroPrice(
            int fieldCount,
            boolean fr,
            boolean di,
            boolean spiel77,
            boolean super6,
            boolean glueck
    ) {

        int draws = 0;
        if (fr) draws++;
        if (di) draws++;

        BigDecimal fieldTotal =
                EURO_FIELD_PRICE
                        .multiply(BigDecimal.valueOf(fieldCount))
                        .multiply(BigDecimal.valueOf(draws));

        BigDecimal extraPerDraw = BigDecimal.ZERO;

        if (spiel77) extraPerDraw = extraPerDraw.add(SPIEL77);
        if (super6) extraPerDraw = extraPerDraw.add(SUPER6);
        if (glueck) extraPerDraw = extraPerDraw.add(GLUECK);

        BigDecimal extraTotal =
                extraPerDraw.multiply(BigDecimal.valueOf(draws));

        return fieldTotal.add(extraTotal);
    }
}