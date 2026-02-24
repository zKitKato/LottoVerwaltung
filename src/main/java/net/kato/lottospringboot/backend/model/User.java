package net.kato.lottospringboot.backend.model;

import jakarta.persistence.*; // JPA-Annotationen für DB-Zuordnung

// Kennzeichnet diese Klasse als JPA-Entity (wird in der DB als Tabelle gespeichert)
@Entity
// Name der Tabelle in der Datenbank: "users"
@Table(name = "users")
public class User {

    // Primärschlüssel der Tabelle
    @Id
    // Auto-Inkrement für die ID (DB generiert automatisch)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Spalte "username", darf nicht null sein, muss eindeutig sein
    @Column(nullable = false, unique = true)
    private String username;

    // Spalte "password", darf nicht null sein
    @Column(nullable = false)
    private String password;

    // Spalte "email", darf nicht null sein, muss eindeutig sein
    @Column(nullable = false, unique = true)
    private String email;

    // --- Getter & Setter ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}

/*
@Entity → Spring Data JPA weiß, dass dies eine Tabelle in der DB ist.

@Table(name = "users") → legt den Tabellennamen fest.

@Id + @GeneratedValue → Primärschlüssel mit Auto-Inkrement.

@Column(nullable = false, unique = true) → Pflichtfelder und eindeutige Werte.

Klasse enthält nur Daten + Getter/Setter → klassische JPA-Entity.
 */