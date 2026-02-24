package net.kato.lottospringboot.backend.service;

import net.kato.lottospringboot.backend.dao.UserRepository; // Zugriff auf die Datenbank für User
import net.kato.lottospringboot.backend.model.User; // User-Entity-Klasse
import org.springframework.security.crypto.password.PasswordEncoder; // Für sichere Passwortverschlüsselung
import org.springframework.stereotype.Service; // Kennzeichnet diese Klasse als Spring-Service
import java.util.Optional; // Optional, um null-sichere Rückgaben zu ermöglichen

// Service-Klasse für User-bezogene Logik (Business-Logik)
@Service
public class UserService {

    // Repository, um CRUD-Operationen auf Usern in der DB auszuführen
    private final UserRepository userRepository;

    // PasswordEncoder zum sicheren Hashen von Passwörtern
    private final PasswordEncoder passwordEncoder;

    // Konstruktor-Injektion: Spring setzt automatisch die Repository- und Encoder-Beans ein
    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    // Registrierung eines neuen Users
    public User register(User user) {
        // Passwort vor dem Speichern verschlüsseln (niemals Klartext speichern!)
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        // User in der Datenbank speichern und zurückgeben
        return userRepository.save(user);
    }

    // Suche nach einem User anhand des Benutzernamens
    public Optional<User> findByUsername(String username) {
        // Gibt ein Optional<User> zurück, kann also leer sein, wenn kein User gefunden wurde
        return userRepository.findByUsername(username);
    }

    // Suche nach Email (für Forgot Password)
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
}