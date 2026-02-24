package net.kato.lottospringboot.frontend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    @GetMapping("/login")
    public String login() {
        return "login"; // Spring resolves to /WEB-INF/jsp/login.jsp
    }
    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("contentPage", "index.jsp"); // optional für Content Include
        return "layouts/main-layout";  // ✅ Layout-Pfad
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        model.addAttribute("contentPage", "profile.jsp");
        return "layouts/main-layout";  // ✅ Layout-Pfad
    }

    @GetMapping("/documentation")
    public String docs() {
        return "redirect:http://localhost:3000/docs/welcome";
    }
}