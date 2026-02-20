package net.kato.lottospringboot.backend.service;

import org.springframework.stereotype.Service;

@Service
public class LottoService {

    public String getWelcomeMessage() {
        return "Lotto System läuft!";
    }

}