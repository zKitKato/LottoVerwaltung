---
id: architektur
title: Technische Architektur & Stack
sidebar_label: Architektur & Stack
---

# Technische Architektur

Diese Seite beschreibt das technologische Fundament der Lotto-Verwaltungs-Applikation. Das Projekt basiert auf dem
Java-Ekosystem und nutzt moderne Frameworks für Backend-Logik und Web-Rendering.

---

## Kern-Technologien

Basierend auf der Projektkonfiguration (`pom.xml`) kommen folgende Hauptkomponenten zum Einsatz:

### Framework & Laufzeit

* **Spring Boot 3.5.11**: Als Basis-Framework für die gesamte Applikationssteuerung, Dependency Injection und das
  Konfigurationsmanagement.
* **Java 17**: Die gewählte LTS-Version (Long Term Support) für eine stabile und performante Laufzeitumgebung.
* **Apache Maven**: Dient als Build-Management-Tool zur Verwaltung von Abhängigkeiten und dem Build-Lebenszyklus.

### Web-Schnittstelle & Rendering

Im Gegensatz zu modernen Single-Page-Applications (SPA) setzt dieses Projekt auf ein **serverseitiges Rendering**:

* **Spring Web MVC**: Zur Steuerung der HTTP-Anfragen und Verteilung an die entsprechenden Controller.
* **JSP (JavaServer Pages)**: Als Template-Engine für die Darstellung der Benutzeroberfläche.
    * Genutzte Bibliotheken: `tomcat-embed-jasper` und `jakarta.servlet.jsp.jstl`.
    * Integration: Über `spring-security-taglibs` werden Sicherheitsfunktionen direkt in den Views gesteuert (z. B.
      bedingte Anzeige von Elementen basierend auf dem Login-Status).
* **Packaging**: Die Applikation wird als **WAR-Datei** (`finalName: lotto`) gebaut, um sie in einem Servlet-Container
  wie Tomcat auszuführen.

---

## Datenhaltung & Persistenz

* **Spring Data JPA (Hibernate)**: Abstraktionsebene für den Datenbankzugriff. Die Tabellenstruktur wird automatisch
  über die Modelle generiert (`ddl-auto: update`).
* **H2 Database**: Eine eingebettete SQL-Datenbank, die im aktuellen Setup als dateibasierte Datenbank genutzt wird (
  `jdbc:h2:file:./data/lotto`). Dies ermöglicht einen schnellen Start ohne externe Datenbank-Installation.

---

## Sicherheit & Dienstprogramme

* **Spring Security**: Übernimmt die Authentifizierung und Autorisierung der Benutzer. Passwörter werden sicher über den
  `PasswordEncoder` verschlüsselt.
* **Project Lombok**: Reduziert Boilerplate-Code (Getter, Setter, Konstruktoren) durch Annotationen direkt im Quellcode.
* **Spring Boot Actuator**: Stellt Endpunkte zur Überwachung und zum Management der Applikation bereit.

---

## Beispiel: Projekt-Konfiguration (Auszug pom.xml)

Um die Abhängigkeiten nachvollziehen zu können, dient die folgende `pom.xml` als Referenz für die Build-Konfiguration:

```xml
<properties>
    <java.version>17</java.version>
</properties>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    
    <dependency>
        <groupId>org.apache.tomcat.embed</groupId>
        <artifactId>tomcat-embed-jasper</artifactId>
    </dependency>
</dependencies>