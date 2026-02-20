package net.kato.lottospringboot.backend.controller;

import net.kato.lottospringboot.backend.service.LottoService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApiController {

    private final LottoService lottoService;

    public ApiController(LottoService lottoService) {
        this.lottoService = lottoService;
    }

    @GetMapping("/api/status")
    public String status() {
        return lottoService.getWelcomeMessage();
    }

}