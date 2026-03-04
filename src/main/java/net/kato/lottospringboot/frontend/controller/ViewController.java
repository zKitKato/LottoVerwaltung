package net.kato.lottospringboot.frontend.controller;

import net.kato.lottospringboot.backend.dao.*;
import net.kato.lottospringboot.backend.model.*;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
public class ViewController {

    private final GameDrawEuroRepository gameDrawEuroRepository;
    private final GameDrawLottoRepository gameDrawLottoRepository;
    private final PlayerRepository playerRepository;
    private final TicketRepository ticketRepository;
    private final FieldRepository fieldRepository;

    public ViewController(GameDrawEuroRepository gameDrawEuroRepository,
                          GameDrawLottoRepository gameDrawLottoRepository,
                          PlayerRepository playerRepository,
                          TicketRepository ticketRepository,
                          FieldRepository fieldRepository
    ) {
        this.gameDrawEuroRepository = gameDrawEuroRepository;
        this.gameDrawLottoRepository = gameDrawLottoRepository;
        this.playerRepository = playerRepository;
        this.ticketRepository = ticketRepository;
        this.fieldRepository = fieldRepository;
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

        model.addAttribute("allPlayers", playerRepository.findAll());

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

        // Neu: alle Spieler für die Navbar-Suche
        List<Player> allPlayers = playerRepository.findAll();


        model.addAttribute("players", players);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("reverseSortDir",
                sortDir.equals("asc") ? "desc" : "asc");
        model.addAttribute("allPlayers", allPlayers);


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

    // Spieler bearbeiten speichern
    @PostMapping("/management/player/edit/{id}")
    public String updatePlayer(
            @PathVariable Long id,
            @RequestParam String username,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate spieltMitSeit,
            @RequestParam String spiele,
            @RequestParam BigDecimal kontostand,
            @RequestParam String status
    ) {
        Player player = playerRepository.findById(id).orElseThrow();

        player.setUsername(username);
        player.setSpieltMitSeit(spieltMitSeit);
        player.setSpiele(spiele);
        player.setKontostand(kontostand);
        player.setStatus(status);

        playerRepository.save(player);
        return "redirect:/management/player-table";
    }

    // Spieler löschen
    @PostMapping("/management/player/delete/{id}")
    public String deletePlayer(@PathVariable Long id) {

        Player player = playerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ungültige ID: " + id));

        playerRepository.delete(player);

        return "redirect:/management/player-table";
    }

    @GetMapping("/management/player/{id}")
    public String viewPlayerProfile(@PathVariable Long id, Model model) {
        Player player = playerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ungültige ID: " + id));

        List<Ticket> tickets = ticketRepository.findByPlayer(player);

        model.addAttribute("player", player);
        model.addAttribute("tickets", tickets);

        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/management/player-profile.jsp");

        return "layout/main-layout";
    }

    // =========================
    // Ticket-Tabelle anzeigen
    // =========================
    @GetMapping("/management/ticket-table")
    public String loadTickets(
            @RequestParam(required = false) String keyword,
            Model model
    ) {

        List<Ticket> tickets;

        if (keyword != null && !keyword.isBlank()) {
            tickets = ticketRepository.findAll((root, query, cb) -> {
                var playerJoin = root.join("player");
                var predicateUsername = cb.like(cb.lower(playerJoin.get("username")), "%" + keyword.toLowerCase() + "%");
                return predicateUsername;
            });
        } else {
            tickets = ticketRepository.findAll();
        }

        List<Player> allPlayers = playerRepository.findAll(Sort.by("username"));

        model.addAttribute("tickets", tickets);
        model.addAttribute("allPlayers", allPlayers);
        model.addAttribute("keyword", keyword);

        // Letzte Ziehungszahlen für Extra-Zahlen
        GameDrawLotto latestLotto = gameDrawLottoRepository.findTopByOrderByIdDesc();
        GameDrawEuro latestEuro = gameDrawEuroRepository.findTopByOrderByIdDesc();

        model.addAttribute("latestLottoExtra", latestLotto != null ? latestLotto.getExtraNumbers() : "0");
        model.addAttribute("latestEuroExtra", latestEuro != null ? latestEuro.getExtraNumbers() : "0");

        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/management/ticket-table.jsp");
        return "layout/main-layout";
    }

    // =========================
    // Ticket hinzufügen
    // =========================
    @PostMapping("/management/ticket/add")
    public String addTicket(
            @RequestParam Long playerId,
            @RequestParam String gameType,
            @RequestParam String fieldsInput, // z.B. "1,2,3,4,5,6;7,8,9,10,11,12"
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate playDate
    ) {
        // Spieler laden
        Player player = playerRepository.findById(playerId)
                .orElseThrow(() -> new IllegalArgumentException("Ungültige Spieler-ID: " + playerId));

        // Neues Ticket erstellen
        Ticket ticket = new Ticket();
        ticket.setPlayer(player);
        ticket.setGameType(gameType);
        ticket.setDrawDate(playDate);

        // Felder erstellen
        List<Field> fields = new ArrayList<>();
        String[] fieldArr = fieldsInput.split(";");

        BigDecimal totalPrice = BigDecimal.ZERO;
        BigDecimal pricePerField = gameType.equalsIgnoreCase("Lotto") ? BigDecimal.valueOf(1.2) : BigDecimal.valueOf(2.0);

        for (String f : fieldArr) {
            String[] parts = f.split(",");
            String extraNumber = "0";
            String numbers = f;

            if (parts.length > 6) {
                extraNumber = parts[parts.length - 1];
                String[] numberParts = Arrays.copyOfRange(parts, 0, parts.length - 1);
                numbers = String.join(",", numberParts);
            }

            Field field = new Field();
            field.setNumbers(numbers);
            field.setExtraNumber(extraNumber);
            field.setTicket(ticket); // WICHTIG für Cascade.ALL
            fields.add(field);

            totalPrice = totalPrice.add(pricePerField);
        }

        ticket.setFields(fields);
        ticket.setTotalPrice(totalPrice);

        // Ticket + Fields speichern
        ticketRepository.save(ticket);

        return "redirect:/management/ticket-table";
    }

    // =========================
    // Ticket bearbeiten
    // =========================
    @PostMapping("/management/ticket/edit/{id}")
    public String editTicket(
            @PathVariable Long id,
            @RequestParam Long playerId,
            @RequestParam String gameType,
            @RequestParam String fieldsInput,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate playDate
    ) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ungültige Ticket-ID: " + id));

        Player player = playerRepository.findById(playerId)
                .orElseThrow(() -> new IllegalArgumentException("Ungültige Spieler-ID: " + playerId));

        ticket.setPlayer(player);
        ticket.setGameType(gameType);
        ticket.setDrawDate(playDate);

        // Alte Felder löschen
        fieldRepository.deleteAll(ticket.getFields());

        // Neue Felder erstellen
        List<Field> fields = new ArrayList<>();
        String[] fieldArr = fieldsInput.split(";");

        BigDecimal totalPrice = BigDecimal.ZERO;
        BigDecimal pricePerField = gameType.equalsIgnoreCase("Lotto") ? BigDecimal.valueOf(1.2) : BigDecimal.valueOf(2.0);

        for (String f : fieldArr) {
            String[] parts = f.split(",");
            String extraNumber = "0";
            String numbers = f;

            if (parts.length > 6) {
                extraNumber = parts[parts.length - 1];
                String[] numberParts = Arrays.copyOfRange(parts, 0, parts.length - 1);
                numbers = String.join(",", numberParts);
            }

            Field field = new Field();
            field.setNumbers(numbers);
            field.setExtraNumber(extraNumber);
            field.setTicket(ticket);
            fields.add(field);

            totalPrice = totalPrice.add(pricePerField);
        }

        ticket.setFields(fields);
        ticket.setTotalPrice(totalPrice);

        ticketRepository.save(ticket);
        return "redirect:/management/ticket-table";
    }

    // =========================
    // Ticket löschen
    // =========================
    @PostMapping("/management/ticket/delete/{id}")
    public String deleteTicket(@PathVariable Long id) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ungültige Ticket-ID: " + id));
        ticketRepository.delete(ticket);
        return "redirect:/management/ticket-table";
    }


    @GetMapping("/error")
    public String error(Model model) {
        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/error.jsp");

        return "layout/main-layout";
    }

    // Externe Dokumentation
    @GetMapping("/documentation")
    public String docs() {
        return "redirect:http://localhost:3000/docs/intro";
    }
}