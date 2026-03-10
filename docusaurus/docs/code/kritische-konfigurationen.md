---
id: kritische-konfigurationen
title: Entwickler-Konfiguration & Sicherheit
sidebar_label: Wichtige Änderungen
---

# Kritische Konfigurationen

In diesem Bereich werden Code-Bestandteile dokumentiert, die für den Entwicklungsbetrieb notwendig sind, aber vor einem
produktiven Rollout (Production-Ready) zwingend angepasst oder entfernt werden müssen.

---

## Initialer Testbenutzer (DataInitializer)

Um den Einstieg in die Applikation nach der Installation zu erleichtern, verfügt das System über einen
`DataInitializer`. Dieser erstellt beim ersten Start automatisch einen Testbenutzer, sofern noch keine Benutzerdatenbank
existiert.

### Quellcode-Auszug

Die Logik befindet sich in der Klasse `DataInitializer.java`:

```java
package net.kato.lottospringboot.backend.config;

// ... Imports

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initUsers(UserRepository userRepository,
                                PasswordEncoder passwordEncoder) {
        return args -> {

            if (userRepository.findByUsername("test").isEmpty()) {

                User user = new User(
                        "test",
                        passwordEncoder.encode("1234")
                );

                userRepository.save(user);

                System.out.println("Testuser erstellt:");
                System.out.println("Username: test");
                System.out.println("Password: 1234");
            }
        };
    }
}
```

---

## Authentifizierungs-Service (CustomUserDetailsService)

Die Klasse `CustomUserDetailsService` ist das Bindeglied zwischen der Datenbank (`UserRepository`) und dem Spring
Security Framework. Sie ist dafür verantwortlich, die Benutzerdaten während des Login-Vorgangs zu validieren.

### Quellcode-Auszug

```java
@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username)
            throws UsernameNotFoundException {

        User user = userRepository.findByUsername(username)
                .orElseThrow(() ->
                        new UsernameNotFoundException("User not found"));

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getUsername())
                .password(user.getPassword())
                .roles("USER") // Statische Rollenzuweisung
                .build();
    }
}