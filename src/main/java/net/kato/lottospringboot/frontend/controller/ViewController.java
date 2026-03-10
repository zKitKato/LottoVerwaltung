package net.kato.lottospringboot.frontend.controller;

import net.kato.lottospringboot.backend.dao.*;
import net.kato.lottospringboot.backend.model.*;
import net.kato.lottospringboot.backend.service.TicketPriceService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

@Controller
public class ViewController {

    private final GameDrawEuroRepository gameDrawEuroRepository;
    private final GameDrawLottoRepository gameDrawLottoRepository;
    private final PlayerRepository playerRepository;
    private final EuroFieldRepository euroFieldRepository;
    private final LottoFieldRepository lottoFieldRepository;
    private final EuroTicketRepository euroTicketRepository;
    private final LottoTicketRepository lottoTicketRepository;
    private final TicketPriceService ticketPriceService;
    private final TicketOverviewRepository ticketOverviewRepository;

    public ViewController(GameDrawEuroRepository gameDrawEuroRepository,
                          GameDrawLottoRepository gameDrawLottoRepository,
                          PlayerRepository playerRepository,
                          EuroTicketRepository euroTicketRepository,
                          LottoTicketRepository lottoTicketRepository,
                          EuroFieldRepository euroFieldRepository,
                          LottoFieldRepository lottoFieldRepository,
                          TicketPriceService ticketPriceService, TicketOverviewRepository ticketOverviewRepository
    ) {
        this.gameDrawEuroRepository = gameDrawEuroRepository;
        this.gameDrawLottoRepository = gameDrawLottoRepository;
        this.playerRepository = playerRepository;
        this.euroFieldRepository = euroFieldRepository;
        this.euroTicketRepository = euroTicketRepository;
        this.lottoFieldRepository = lottoFieldRepository;
        this.lottoTicketRepository = lottoTicketRepository;
        this.ticketPriceService = ticketPriceService;
        this.ticketOverviewRepository = ticketOverviewRepository;
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
    @ResponseBody // Wichtig: Wir senden Daten/Status, keine HTML-Seite
    public ResponseEntity<?> addPlayer(
            @RequestParam String username,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate spieltMitSeit,
            @RequestParam String spiele,
            @RequestParam BigDecimal kontostand,
            @RequestParam String status
    ) {
        try {
            Player player = new Player();
            player.setUsername(username);
            player.setSpieltMitSeit(spieltMitSeit);
            player.setSpiele(spiele);
            player.setKontostand(kontostand);
            player.setStatus(status);

            playerRepository.save(player);

            // Erfolg: Wir senden ein leeres OK (200)
            return ResponseEntity.ok().build();

        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            // Fehler: Name existiert bereits (409 Conflict)
            return ResponseEntity.status(org.springframework.http.HttpStatus.CONFLICT)
                    .body("Der Spielername '" + username + "' ist bereits vergeben.");
        } catch (Exception e) {
            // Allgemeiner Fehler (500)
            return ResponseEntity.internalServerError()
                    .body("Ein unerwarteter Fehler ist aufgetreten.");
        }
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

        // Wir holen die echten Tickets, damit wir auf .getFields() zugreifen können
        List<TicketLotto> lottoTickets = lottoTicketRepository.findByPlayer(player);
        List<TicketEuro> euroTickets = euroTicketRepository.findByPlayer(player);

        // Alles in eine Liste für die Tabelle
        List<Object> allTickets = new ArrayList<>();
        allTickets.addAll(lottoTickets);
        allTickets.addAll(euroTickets);

        model.addAttribute("player", player);
        model.addAttribute("tickets", allTickets);
        model.addAttribute("contentPage", "/WEB-INF/jsp/pages/management/player-profile.jsp");

        return "layout/main-layout";
    }

    // =========================
    // Ticket-Tabelle anzeigen
    // =========================
    @GetMapping("/management/ticket-table")
    public String loadTickets(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "createdAt") String sortField,
            @RequestParam(defaultValue = "desc") String sortDir,
            Model model
    ) {
        Sort sort = sortDir.equalsIgnoreCase("asc") ?
                Sort.by(sortField).ascending() :
                Sort.by(sortField).descending();

        List<TicketOverview> tickets;

        if (keyword != null && !keyword.isBlank()) {
            // Bei einer Suche zeigen wir alle Treffer (meist eh wenige)
            tickets = ticketOverviewRepository.findByUsernameOptimized(keyword, sort);
        } else {
            // Ohne Suche: Nur die ersten 10 (Page 0, Size 10)
            Pageable limitTen = PageRequest.of(0, 10, sort);
            tickets = ticketOverviewRepository.findAll(limitTen).getContent();
        }

        model.addAttribute("tickets", tickets);
        // Optimierung: Nur Spieler-Namen und IDs laden, nicht das ganze Objekt
        model.addAttribute("allPlayers", playerRepository.findAll(Sort.by("username")));

        model.addAttribute("keyword", keyword);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");

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
            @RequestParam String fieldsInput,
            @RequestParam String drawDay,
            @RequestParam String losnummer, // Wichtig: Muss im JSP name="losnummer" entsprechen
            @RequestParam(required = false, defaultValue = "1") int weeks,
            @RequestParam(required = false) boolean spiel77,
            @RequestParam(required = false) boolean super6,
            @RequestParam(required = false) boolean glueck,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate validFrom
    ) {

        Player player = playerRepository.findById(playerId).orElseThrow();

        if (gameType.equalsIgnoreCase("LOTTO")) {
            TicketLotto ticket = new TicketLotto();
            ticket.setPlayer(player);
            ticket.setLosnummer(losnummer); // Behebt den Null-Fehler
            ticket.setWednesday(drawDay.contains("MI") || drawDay.equals("BOTH"));
            ticket.setSaturday(drawDay.contains("SA") || drawDay.equals("BOTH"));
            ticket.setWeeksDuration(weeks);
            ticket.setSpiel77(spiel77);
            ticket.setSuper6(super6);
            ticket.setGluecksspirale(glueck);
            ticket.setValidFrom(validFrom);

            List<LottoField> fields = new ArrayList<>();
            // JS sendet Felder getrennt durch Pipe: "1,2,3,4,5,6,S|..."
            String[] fieldArr = fieldsInput.split("\\|");

            for (String f : fieldArr) {
                if (f.isBlank()) continue;
                String[] parts = f.split(",");

                // Die ersten 6 sind Zahlen, der 7. Wert ist die Superzahl aus dem JS
                String numbers = String.join(",", Arrays.copyOfRange(parts, 0, 6));
                Integer superNumber = Integer.parseInt(parts[6]);

                LottoField field = new LottoField();
                field.setNumbers(numbers);
                field.setSuperNumber(superNumber);
                field.setLottoTicket(ticket);
                fields.add(field);
            }
            ticket.setFields(fields);

            BigDecimal total = ticketPriceService.calcLottoPrice(fields.size(),
                    ticket.isWednesday(), ticket.isSaturday(), weeks,
                    spiel77, super6, glueck);
            ticket.setTotalPrice(total);

            lottoTicketRepository.save(ticket);

        } else {
            // EuroTicket
            TicketEuro ticket = new TicketEuro();
            ticket.setPlayer(player);
            ticket.setLosnummer(losnummer); // Auch hier setzen!
            ticket.setValidFrom(validFrom);
            ticket.setSpiel77(spiel77);
            ticket.setSuper6(super6);
            ticket.setGluecksspirale(glueck);
            // Eurojackpot nutzt drawCount oft für die Laufzeit
            ticket.setDrawCount(weeks);

            List<EuroField> fields = new ArrayList<>();
            // JS sendet: "1,2,3,4,5;1,2|..."
            String[] fieldArr = fieldsInput.split("\\|");

            for (String f : fieldArr) {
                if (f.isBlank()) continue;
                String[] areaSplit = f.split(";"); // Trennt Zahlen von Eurozahlen

                EuroField field = new EuroField();
                field.setNumbers(areaSplit[0]);     // "1,2,3,4,5"
                field.setEuroNumbers(areaSplit[1]); // "1,2"
                field.setEuroTicket(ticket);
                fields.add(field);
            }
            ticket.setFields(fields);

            BigDecimal total = ticketPriceService.calcEuroPrice(fields.size(),
                    drawDay.contains("FR") || drawDay.equals("BOTH"),
                    drawDay.contains("DI") || drawDay.equals("BOTH"),
                    spiel77, super6, glueck);
            ticket.setTotalPrice(total);

            euroTicketRepository.save(ticket);
        }

        return "redirect:/management/ticket-table";
    }

    @PostMapping("/management/ticket/edit/{gameType}/{id}")
    public String updateTicket(
            @PathVariable String gameType,
            @PathVariable Long id,
            @RequestParam String losnummer,
            @RequestParam String fieldsInput,
            @RequestParam(required = false, defaultValue = "1") int weeks,
            @RequestParam(required = false) boolean spiel77,
            @RequestParam(required = false) boolean super6,
            @RequestParam(required = false) boolean glueck,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate validFrom
    ) {
        if ("LOTTO".equalsIgnoreCase(gameType)) {
            TicketLotto ticket = lottoTicketRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Lotto-Ticket nicht gefunden: " + id));

            ticket.setLosnummer(losnummer);
            ticket.setSpiel77(spiel77);
            ticket.setSuper6(super6);
            ticket.setGluecksspirale(glueck);
            ticket.setValidFrom(validFrom);
            ticket.setWeeksDuration(weeks);

            // --- KORREKTUR START ---
            // Liste leeren statt deleteAll (Hibernate kümmert sich um orphans)
            ticket.getFields().clear();

            List<LottoField> newFields = new ArrayList<>();
            String[] fieldArr = fieldsInput.split("\\|");
            for (String f : fieldArr) {
                if (f.isBlank()) continue;
                String[] parts = f.split(",");
                String numbers = String.join(",", Arrays.copyOfRange(parts, 0, 6));
                Integer superNumber = Integer.parseInt(parts[6]);

                LottoField field = new LottoField();
                field.setNumbers(numbers);
                field.setSuperNumber(superNumber);
                field.setLottoTicket(ticket);
                newFields.add(field);
            }

            // WICHTIG: Bestehende Liste befüllen statt eine neue Liste zu setzen!
            ticket.getFields().addAll(newFields);
            // --- KORREKTUR ENDE ---

            BigDecimal total = ticketPriceService.calcLottoPrice(
                    ticket.getFields().size(), ticket.isWednesday(), ticket.isSaturday(),
                    weeks, spiel77, super6, glueck);
            ticket.setTotalPrice(total);

            lottoTicketRepository.save(ticket);

        } else if ("EURO".equalsIgnoreCase(gameType)) {
            TicketEuro ticket = euroTicketRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Euro-Ticket nicht gefunden: " + id));

            ticket.setLosnummer(losnummer);
            ticket.setSpiel77(spiel77);
            ticket.setSuper6(super6);
            ticket.setGluecksspirale(glueck);
            ticket.setValidFrom(validFrom);
            ticket.setDrawCount(weeks);

            // --- KORREKTUR START ---
            ticket.getFields().clear();

            List<EuroField> newFieldsList = new ArrayList<>();
            String[] fieldArr = fieldsInput.split("\\|");
            for (String f : fieldArr) {
                if (f.isBlank()) continue;
                String[] areaSplit = f.split(";");

                EuroField field = new EuroField();
                field.setNumbers(areaSplit[0]);
                field.setEuroNumbers(areaSplit[1]);
                field.setEuroTicket(ticket);
                newFieldsList.add(field);
            }

            ticket.getFields().addAll(newFieldsList);
            // --- KORREKTUR ENDE ---

            BigDecimal total = ticketPriceService.calcEuroPrice(
                    ticket.getFields().size(), true, true, spiel77, super6, glueck);
            ticket.setTotalPrice(total);

            euroTicketRepository.save(ticket);
        }

        return "redirect:/management/ticket-table";
    }

    @GetMapping("/management/ticket/details/{gameType}/{id}")
    @ResponseBody
    public Map<String, Object> getTicketDetails(@PathVariable String gameType, @PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        if ("LOTTO".equalsIgnoreCase(gameType)) {
            TicketLotto ticket = lottoTicketRepository.findById(id).orElseThrow();
            response.put("type", "LOTTO");
            response.put("playerId", ticket.getPlayer().getId()); // WICHTIG
            response.put("losnummer", ticket.getLosnummer());
            response.put("validFrom", ticket.getValidFrom().toString()); // Als String für das Datum-Feld
            response.put("spiel77", ticket.isSpiel77());
            response.put("super6", ticket.isSuper6());
            response.put("gluecksspirale", ticket.isGluecksspirale());
            response.put("fields", ticket.getFields());
        } else {
            TicketEuro ticket = euroTicketRepository.findById(id).orElseThrow();
            response.put("type", "EURO");
            response.put("playerId", ticket.getPlayer().getId()); // WICHTIG
            response.put("losnummer", ticket.getLosnummer());
            response.put("validFrom", ticket.getValidFrom().toString());
            response.put("spiel77", ticket.isSpiel77());
            response.put("super6", ticket.isSuper6());
            response.put("gluecksspirale", ticket.isGluecksspirale());
            response.put("fields", ticket.getFields());
        }
        return response;
    }

    // =========================
    // Ticket löschen
    // =========================
    @PostMapping("/management/ticket/delete/{gameType}/{id}")
    public String deleteTicket(@PathVariable String gameType, @PathVariable Long id) {
        if (gameType.equalsIgnoreCase("LOTTO")) {
            lottoTicketRepository.deleteById(id);
        } else {
            euroTicketRepository.deleteById(id);
        }
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