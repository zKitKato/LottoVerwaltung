---
id: security-config
title: Sicherheitskonfiguration (Spring Security)
sidebar_label: Security Config
---

# Sicherheitskonfiguration

Die Klasse `SecurityConfig` definiert die Zugriffsregeln der Anwendung. Sie legt fest, welche Bereiche öffentlich
zugänglich sind, wie der Login-Prozess abläuft und wie die Datenbankkonsole (H2) abgesichert wird.

---

## Der Quellcode

```java

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/login", "/h2-console/**", "/assets/**",
                                "/css/**", "/js/**", "/WEB-INF/**"
                        ).permitAll()
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/home", true)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                )
                .csrf(csrf -> csrf.ignoringRequestMatchers("/h2-console/**"))
                .headers(headers -> headers.frameOptions(HeadersConfigurer.FrameOptionsConfig::disable));

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

### 1. Berechtigungen (Request Matching):

- **`permitAll()`:** Bestimmte Pfade müssen ohne Login erreichbar sein. Dazu gehören die Login-Seite selbst, statische
  Ressourcen (CSS/JS) für das Design und die H2-Konsole für die Entwicklung.

- **`anyRequest().authenticated()`:** Dies ist die "Default-Sperre". Alles, was nicht explizit erlaubt wurde (z. B.
  Dashboard,
  Spieler-Verwaltung), erfordert eine erfolgreiche Anmeldung.

### 2. Login & Logout Management

- **`loginPage("/login")`:** Du sagst Spring Security, dass kein Standard-Formular genutzt werden soll, sondern dein
  eigenes
  JSP-Template unter `/login`.

- **`defaultSuccessUrl("/home", true)`:** Nach dem Login wird der User immer zum Dashboard (`/home`) weitergeleitet.

- **Logout-Sicherheit:** Beim Abmelden wird nicht nur die Seite gewechselt, sondern aktiv die HttpSession zerstört und
  das
  `JSESSIONID-Cookie` gelöscht. Das verhindert, dass jemand durch Drücken des "Zurück"-Buttons im Browser wieder in die
  Session gelangt.

### 3. H2-Konsole Sonderregeln

Die H2-Konsole (Web-Interface der Datenbank) benötigt zwei spezielle Ausnahmen, um innerhalb von Spring Boot zu
funktionieren:

- **CSRF Ignoring:** Da die H2-Konsole eigene Formular-Mechanismen nutzt, die nicht mit dem CSRF-Schutz von Spring
  harmonieren, wird dieser für `/h2-console/**` deaktiviert.
  `CSRF = Cross-Site Request Forgery`
- **FrameOptions Disable:** H2 nutzt HTML-Frames. Standardmäßig verbietet Spring Security Frames (Schutz gegen
  Clickjacking).
  Mit `.disable()` erlaubst du der Datenbank-Oberfläche, sich im Browser darzustellen.

### 4. Password Verschlüsselung

```java

@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

## Warum BCrypt? (Deep Dive)

BCrypt ist ein industrieller Standard und ein sogenannter One-Way-Hash-Algorithmus. Das bedeutet: Ein Passwort kann
verschlüsselt, aber niemals wieder in den Klartext zurückgerechnet werden.

Hier sind die drei Säulen, die BCrypt so sicher machen:

### Salting (Das Salz in der Suppe):

BCrypt fügt jedem Passwort vor dem Hashen automatisch einen zufälligen Wert (das "Salt") hinzu. Selbst wenn zwei
Benutzer das identische Passwort 123456 wählen, sehen die Hashes in der Datenbank völlig unterschiedlich aus. Das macht
sogenannte Rainbow Tables (Tabellen mit vorberechneten Passwörtern) nutzlos.

### Key Stretching (Rechenzeit als Schutz):

BCrypt ist absichtlich "langsam" konzipiert. Während ein Computer Millionen von einfachen MD5-Hashes pro Sekunde
berechnen kann, benötigt BCrypt für einen einzigen Hash deutlich mehr Rechenzeit. Für einen legitimen Login (einmalig)
ist das nicht spürbar, aber für einen Angreifer, der Milliarden Kombinationen durchprobieren will (Brute-Force), wird
die benötigte Zeit astronomisch hoch.

### Adaptive Kosten:

Der Algorithmus erlaubt es, den "Work Factor" zu erhöhen. Wenn Computer in 5 Jahren schneller werden, können wir die
Rechenlast einfach hochschrauben, ohne den Algorithmus wechseln zu müssen.
