package net.kato.lottospringboot.frontend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    @GetMapping("/login")
    public String login() {
        return "pages/login";
    }

    @GetMapping("/home")
    public String index() {
        return "layout/main-layout"; // loads /WEB-INF/jsp/main-layout.jsp
    }

    // Redirect endpoint for documentation
    @GetMapping("/documentation")
    public String docs() {
        return "redirect:http://localhost:3000/docs"; // change path to your Docusaurus landing doc
    }
}