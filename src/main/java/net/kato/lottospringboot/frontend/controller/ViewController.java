package net.kato.lottospringboot.frontend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    @GetMapping("/")
    public String index() {
        return "index"; // Spring MVC sucht automatisch nach /WEB-INF/jsp/index.jsp
    }
}