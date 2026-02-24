package net.kato.lottospringboot.backend.controller;

import ch.qos.logback.core.model.Model;
import net.kato.lottospringboot.backend.model.User;
import net.kato.lottospringboot.backend.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

// Kennzeichnet diese Klasse als Controller für Web-Anfragen
@Controller
public class AuthController {

    // Service, der die Logik für Registrierung und Passwort-Hashing übernimmt
    private final UserService userService;

    // Konstruktor-Injektion: Spring setzt automatisch den UserService ein
    public AuthController(UserService userService) {
        this.userService = userService;
    }

    // Methode für POST-Anfragen an /register (z.B. vom Registrierungsformular)
    @PostMapping("/register")
    public String register(
            @RequestParam String username,  // Holt den "username"-Parameter aus dem Formular
            @RequestParam String email,     // Holt den "email"-Parameter
            @RequestParam String password   // Holt das Passwort
    ) {
        // Neues User-Objekt erstellen und Werte setzen
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password); // Passwort wird später vom Service verschlüsselt

        // User in der Datenbank speichern (Passwort wird hier gehasht)
        userService.register(user);

        // Nach erfolgreicher Registrierung zurück zur Login-Seite weiterleiten
        return "redirect:/login.jsp";
    }
    // ================================
    // Forgot Password
    // ================================
    @PostMapping("/forgot-password")
    public String forgotPassword(@RequestParam String email, Model model) {

        Optional<User> optionalUser = userService.findByEmail(email);

        if (optionalUser.isPresent()) {
            // TODO: Hier könnte man ein E-Mail-Token generieren und senden
            model.addAttribute("message", "A reset link has been sent to your email.");
        } else {
            model.addAttribute("error", "Email address not found.");
        }

        // Bleibt auf forgot-password.jsp
        return "forgot-password";
    }
}

/*
@Controller → Diese Klasse verarbeitet Webanfragen und gibt JSP-Seiten oder Redirects zurück.

@PostMapping("/register") → Methode wird aufgerufen, wenn das Formular per POST an /register gesendet wird.

@RequestParam → Extrahiert Formulardaten (username, email, password).

userService.register(user) → Service kümmert sich um das Hashen des Passworts und das Speichern in der DB.

return "redirect:/login.jsp"; → Weiterleitung zur Login-Seite nach erfolgreicher Registrierung.
 */