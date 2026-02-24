package net.kato.lottospringboot.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity; // für Web-Security-Konfiguration
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder; // für sicheres Passwort-Hashing
import org.springframework.security.crypto.password.PasswordEncoder; // Interface für PasswordEncoder
import org.springframework.security.web.SecurityFilterChain; // Filterkette für Security

// Kennzeichnet diese Klasse als Spring-Konfiguration
@Configuration
public class SecurityConfig {

    // Bean zum Verschlüsseln von Passwörtern, wird automatisch von Spring genutzt
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); // BCrypt ist ein sicherer Hash-Algorithmus
    }

    // Haupt-Security-Konfiguration
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Autorisierung: Wer darf was sehen?
                .authorizeHttpRequests(auth -> auth
                        // Diese URLs sind für alle frei zugänglich (Login, Registrierung, JS/CSS)
                        .requestMatchers(
                                "/login.jsp",
                                "/register.jsp",
                                "/forgot-password.jsp",
                                "/css/**",
                                "/js/**"
                        ).permitAll()
                        // Alle anderen Requests erfordern Authentifizierung
                        .anyRequest().authenticated()
                )
                // Login-Konfiguration
                .formLogin(form -> form
                        .loginPage("/login.jsp") // eigene Login-Seite
                        .defaultSuccessUrl("/main-layout.jsp", true) // nach erfolgreichem Login
                        .permitAll() // Login-Seite darf jeder aufrufen
                )
                // Logout-Konfiguration
                .logout(logout -> logout
                        .logoutUrl("/logout") // URL, um sich auszuloggen
                        .logoutSuccessUrl("/login.jsp") // nach Logout weiterleiten
                        .permitAll() // jeder darf logout aufrufen
                )
                // CSRF-Schutz deaktivieren (für einfache JSP-Formulare)
                .csrf(csrf -> csrf.disable());

        // Filterkette bauen und zurückgeben
        return http.build();
    }
}

/*
PasswordEncoder: Verschlüsselt Passwörter sicher.

authorizeHttpRequests: Legt fest, welche Seiten öffentlich sind und welche Authentifizierung brauchen.

formLogin: Eigene Login-Seite konfigurieren.

logout: Logout-URL und Zielseite definieren.

csrf.disable(): Deaktiviert CSRF-Schutz, damit einfache JSP-Formulare ohne Token funktionieren.
 */