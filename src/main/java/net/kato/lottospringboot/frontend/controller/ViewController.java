package net.kato.lottospringboot.frontend.controller;

import net.kato.lottospringboot.backend.dao.GameDrawRepository;
import net.kato.lottospringboot.backend.model.GameDraw;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // <-- wichtig
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    private final GameDrawRepository gameDrawRepository;

    public ViewController(GameDrawRepository gameDrawRepository) {
        this.gameDrawRepository = gameDrawRepository;
    }


    @GetMapping("/login")
    public String login() {
        return "pages/login";
    }

    @GetMapping("/home")
    public String index(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails != null) {
            model.addAttribute("username", userDetails.getUsername());
        }
        GameDraw letzteZiehung = gameDrawRepository.findTopByOrderByIdDesc();

        if (letzteZiehung != null) {
            model.addAttribute("gameDraw", letzteZiehung);
            model.addAttribute("gameName", letzteZiehung.getGameName());
            model.addAttribute("gameDate", letzteZiehung.getGameDate());
            model.addAttribute("jackpot", letzteZiehung.getJackpot());
            model.addAttribute("nextDeadlineDate", letzteZiehung.getNextDeadlineDate());
        }
        return "layout/main-layout";
    }

    @GetMapping("/documentation")
    public String docs() {
        return "redirect:http://localhost:3000/docs/intro";
    }
}