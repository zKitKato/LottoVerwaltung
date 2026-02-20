package net.kato.lottospringboot.frontend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    @GetMapping("/")
    public String index() {
        return "main-layout"; // Spring sucht /WEB-INF/jsp/main-layout.jsp
    }
}
