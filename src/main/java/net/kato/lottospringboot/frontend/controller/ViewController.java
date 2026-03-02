package net.kato.lottospringboot.frontend.controller;

import net.kato.lottospringboot.backend.dao.GameDrawEuroRepository;
import net.kato.lottospringboot.backend.dao.GameDrawLottoRepository;
import net.kato.lottospringboot.backend.dao.PlayerRepository;
import net.kato.lottospringboot.backend.model.GameDrawEuro;
import net.kato.lottospringboot.backend.model.GameDrawLotto;
import net.kato.lottospringboot.backend.model.Player;
import net.kato.lottospringboot.backend.specification.PlayerSpecification;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Controller
public class ViewController {

    private final GameDrawEuroRepository gameDrawEuroRepository;
    private final GameDrawLottoRepository gameDrawLottoRepository;
    private final PlayerRepository playerRepository;

    public ViewController(GameDrawEuroRepository gameDrawEuroRepository,
                          GameDrawLottoRepository gameDrawLottoRepository,
                          PlayerRepository playerRepository) {
        this.gameDrawEuroRepository = gameDrawEuroRepository;
        this.gameDrawLottoRepository = gameDrawLottoRepository;
        this.playerRepository = playerRepository;
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

        if (euroDaten != null) model.addAttribute("gameDrawEuro", euroDaten);
        if (lottoDaten != null) model.addAttribute("gameDrawLotto", lottoDaten);

        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/dashboard.jsp");
        return "layout/main-layout";
    }

    // Addon-Seiten
    @GetMapping("/addons/{page}")
    public String loadAddon(@PathVariable String page, Model model) {
        if ("euro-table".equals(page)) model.addAttribute("gameEuro", gameDrawEuroRepository.findAll());
        else if ("lotto-table".equals(page)) model.addAttribute("gameLotto", gameDrawLottoRepository.findAll());

        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/addons/" + page + ".jsp");
        return "layout/main-layout";
    }

    @GetMapping("/management/player-table")
    public String loadPlayers(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "id") String sortField,
            @RequestParam(defaultValue = "asc") String sortDir,
            Model model
    ) {

        // Erlaubte Sortierfelder
        List<String> allowedFields = List.of(
                "id", "username", "spieltMitSeit",
                "spiele", "kontostand", "status"
        );

        if (!allowedFields.contains(sortField)) {
            sortField = "id";
        }

        Sort sort = sortDir.equalsIgnoreCase("asc") ?
                Sort.by(sortField).ascending() :
                Sort.by(sortField).descending();

        List<Player> players;

        if (keyword != null && !keyword.isBlank()) {
            players = playerRepository
                    .findByUsernameContainingIgnoreCase(keyword, sort);
        } else {
            players = playerRepository.findAll(sort);
        }

        model.addAttribute("players", players);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("reverseSortDir",
                sortDir.equals("asc") ? "desc" : "asc");

        model.addAttribute("contentPage",
                "/WEB-INF/jsp/pages/management/player-table.jsp");

        return "layout/main-layout";
    }

    // Spieler hinzufügen
    @PostMapping("/management/player/add")
    public String addPlayer(
            @RequestParam String username,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate spieltMitSeit,
            @RequestParam String spiele,
            @RequestParam BigDecimal kontostand,
            @RequestParam String status
    ) {
        Player player = new Player();
        player.setUsername(username);
        player.setSpieltMitSeit(spieltMitSeit);
        player.setSpiele(spiele);
        player.setKontostand(kontostand);
        player.setStatus(status);

        playerRepository.save(player);
        return "redirect:/management/player-table";
    }

    // Externe Dokumentation
    @GetMapping("/documentation")
    public String docs() {
        return "redirect:http://localhost:3000/docs/intro";
    }
}