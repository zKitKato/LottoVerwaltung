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
```

---

## Mehrbenutzerfähigkeit

Mehrbenutzerfähigkeit & Thread-Modell
Ein zentraler Aspekt der Lotto-Applikation ist die Fähigkeit, Anfragen von vielen Spielern gleichzeitig zu verarbeiten.
Spring Boot nutzt hierfür den eingebetteten Apache Tomcat Webserver.

Das "Thread-per-Request"-Modell
Tomcat arbeitet standardmäßig nach dem Thread-per-Request-Prinzip. Das bedeutet:

Thread-Pool: Beim Start der Applikation initialisiert Tomcat einen Pool von Worker-Threads (standardmäßig bis zu 200).

Zuweisung: Jede eingehende HTTP-Anfrage eines Nutzers wird von einem freien Thread aus diesem Pool übernommen.

Isolierung: Dieser Thread begleitet die Anfrage durch den gesamten Lebenszyklus – vom Controller über den Service bis
zur Datenbank und zurück.

Freigabe: Sobald die Antwort (JSP/HTML) an den Browser gesendet wurde, kehrt der Thread in den Pool zurück und steht für
den nächsten Benutzer zur Verfügung.

Visualisierung der Verarbeitung
Wenn Spieler A ein Ticket kauft und Spieler B gleichzeitig seinen Kontostand prüft, geschieht Folgendes:

Thread 1 bearbeitet TicketPriceService.calcLottoPrice() für Spieler A.

Thread 2 liest parallel dazu die Daten aus dem PlayerRepository für Spieler B.

Thread-Sicherheit in Spring-Beans
Da Spring-Beans (Controller, Services, Repositories) standardmäßig Singletons sind (es existiert nur eine Instanz pro
Anwendung), müssen sie so programmiert sein, dass sie von mehreren Threads gleichzeitig sicher genutzt werden können.

Statelessness (Zustandslosigkeit): Unsere Services (z. B. TicketPriceService) speichern keine nutzerspezifischen Daten
in Klassenvariablen. Daten werden nur innerhalb von Methoden verarbeitet und als lokale Variablen auf dem Stack des
jeweiligen Threads gehalten.

Datenbank-Isolierung: Die H2-Datenbank und Spring Data JPA sorgen dafür, dass Datenbanktransaktionen voneinander
isoliert bleiben, selbst wenn zwei Threads gleichzeitig auf dieselbe Tabelle zugreifen.

Wichtige Konfigurationsparameter
In der application.properties kann das Verhalten des Webservers für hohe Lasten angepasst werden:

```
# Maximale Anzahl gleichzeitiger Worker-Threads (Standard: 200)

server.tomcat.threads.max=200

# Mindestanzahl an Threads, die immer bereitgehalten werden

server.tomcat.threads.min-spare=10

# Maximale Anzahl an Verbindungen, die Tomcat akzeptiert

server.tomcat.max-connections=8192
```

### Quellen

Offizielle Ressourcen & Dokumentation
Für tiefergehende technische Details zum Threading-Modell und zur Performance-Optimierung verweisen wir auf die
offizielle Dokumentation:

[Spring Boot Reference: Embedded Web Servers](https://docs.spring.io/spring-boot/how-to/webserver.html) – Offizielle
Anleitung zur Konfiguration von Tomcat.

[Apache Tomcat 9 Configuration: The HTTP Connector](https://tomcat.apache.org/tomcat-9.0-doc/config/http.html) –
Detailierte Beschreibung, wie Tomcat Verbindungen und Threads
verwaltet.

[Spring Security Concurrency Support](https://docs.spring.io/spring-security/reference/servlet/integrations/concurrency.html) –
Erklärt, wie der Sicherheitskontext (SecurityContext) über Threads hinweg stabil
gehalten wird.
