package net.kato.lottospringboot.backend.specification;

import net.kato.lottospringboot.backend.model.Player;
import org.springframework.data.jpa.domain.Specification;

import java.math.BigDecimal;
import java.time.LocalDate;

public class PlayerSpecification {

    public static Specification<Player> filter(
            String username,
            LocalDate spieltSeit,
            String spielTyp,
            String status,
            BigDecimal minKontostand,
            BigDecimal maxKontostand) {

        return (root, query, cb) -> {

            var predicates = cb.conjunction();

            if (username != null && !username.isEmpty()) {
                predicates = cb.and(predicates,
                        cb.like(cb.lower(root.get("username")),
                                "%" + username.toLowerCase() + "%"));
            }

            if (spieltSeit != null) {
                predicates = cb.and(predicates,
                        cb.greaterThanOrEqualTo(root.get("spieltMitSeit"), spieltSeit));
            }

            if (spielTyp != null && !spielTyp.isEmpty()) {
                predicates = cb.and(predicates,
                        cb.like(cb.lower(root.get("spiele")),
                                "%" + spielTyp.toLowerCase() + "%"));
            }

            if (status != null && !status.isEmpty()) {
                predicates = cb.and(predicates,
                        cb.equal(cb.lower(root.get("status")),
                                status.toLowerCase()));
            }

            if (minKontostand != null) {
                predicates = cb.and(predicates,
                        cb.greaterThanOrEqualTo(root.get("kontostand"), minKontostand));
            }

            if (maxKontostand != null) {
                predicates = cb.and(predicates,
                        cb.lessThanOrEqualTo(root.get("kontostand"), maxKontostand));
            }

            return predicates;
        };
    }
}