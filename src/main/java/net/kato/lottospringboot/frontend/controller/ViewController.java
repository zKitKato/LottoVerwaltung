package net.kato.lottospringboot.frontend.controller;

import net.kato.lottospringboot.backend.dao.GameDrawEuroRepository;
import net.kato.lottospringboot.backend.dao.GameDrawLottoRepository;
import net.kato.lottospringboot.backend.model.GameDrawEuro;
import net.kato.lottospringboot.backend.model.GameDrawLotto;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class ViewController {

    private final GameDrawEuroRepository gameDrawEuroRepository;
    private final GameDrawLottoRepository gameDrawLottoRepository;

    public ViewController(GameDrawEuroRepository gameDrawEuroRepository, GameDrawLottoRepository gameDrawLottoRepository) {
        this.gameDrawEuroRepository = gameDrawEuroRepository;
        this.gameDrawLottoRepository = gameDrawLottoRepository;
    }

    // Login
    @GetMapping("/login")
    public String login() {
        return "pages/login";
    }

    // Dashboard
    @GetMapping({"/", "/home"})
    public String index(@AuthenticationPrincipal UserDetails userDetails, Model model) {

        if (userDetails != null) {
            model.addAttribute("username", userDetails.getUsername());
        }

        GameDrawEuro euroDaten = gameDrawEuroRepository.findTopByOrderByIdDesc();
        GameDrawLotto lottoDaten = gameDrawLottoRepository.findTopByOrderByIdDesc();

        if (euroDaten != null && lottoDaten != null) {
            model.addAttribute("gameDrawEuro", euroDaten);
            model.addAttribute("gameDrawLotto", lottoDaten);
        }

        // Dashboard JSP
        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/dashboard.jsp");

        return "layout/main-layout";
    }

    // Dynamische Addon-Seiten, z. B. /addons/euro-table oder /addons/lotto-table
    @GetMapping("/addons/{page}")
    public String loadAddon(@PathVariable("page") String page, Model model) {

        // Datenbankabfragen für spezifische Seiten
        if ("euro-table".equals(page)) {
            model.addAttribute("gameEuro", gameDrawEuroRepository.findAll());
        } else if ("lotto-table".equals(page)) {
            model.addAttribute("gameLotto", gameDrawLottoRepository.findAll());
        }

        // Dynamisches JSP-Fragment laden
        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/addons/" + page + ".jsp");

        return "layout/main-layout";
    }

    // Externe Dokumentation
    @GetMapping("/documentation")
    public String docs() {
        return "redirect:http://localhost:3000/docs/intro";
    }
}