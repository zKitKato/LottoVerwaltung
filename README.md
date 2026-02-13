# LottoVerwaltung

Dieses Projekt ist eine Multi-Module Java-Webanwendung zur Verwaltung von Lotto-Spielen.  
Es besteht aus zwei Modulen:

- **backend**: Enthält die Logik, Datenbankzugriffe (H2 + Hibernate) und Services
- **frontend**: Enthält JSP-Seiten, Servlets und das Web-Interface

Die Anwendung wird auf **Apache Tomcat 9** deployt und mit **Java 17** kompiliert.

---

## Projektstruktur

```
.
├── backend
│   ├── pom.xml
│   ├── src
│   │   ├── main
│   │   │   ├── java
│   │   │   │   └── com
│   │   │   │       └── lotto
│   │   │   │           ├── backend
│   │   │   │           ├── config
│   │   │   │           │   └── HibernateConfig.java
│   │   │   │           ├── controller
│   │   │   │           ├── dao
│   │   │   │           └── service
│   │   │   └── resources
│   │   └── test
│   │       └── java
│   └── target
│       ├── classes
│       │   └── com
│       │       └── lotto
│       │           └── config
│       │               └── HibernateConfig.class
│       ├── generated-sources
│       │   └── annotations
│       ├── generated-test-sources
│       │   └── test-annotations
│       ├── maven-archiver
│       │   └── pom.properties
│       ├── maven-status
│       │   └── maven-compiler-plugin
│       │       ├── compile
│       │       │   └── default-compile
│       │       │       ├── createdFiles.lst
│       │       │       └── inputFiles.lst
│       │       └── testCompile
│       │           └── default-testCompile
│       │               ├── createdFiles.lst
│       │               └── inputFiles.lst
│       ├── module-backend-1.0-SNAPSHOT.jar
│       └── test-classes
├── frontend
│   ├── pom.xml
│   ├── src
│   │   ├── main
│   │   │   ├── java
│   │   │   ├── resources
│   │   │   └── webapp
│   │   │       ├── index.jsp
│   │   │       ├── web
│   │   │       │   └── WEB-INF
│   │   │       │       └── web.xml
│   │   │       └── WEB-INF
│   │   │           └── web.xml
│   │   └── test
│   │       └── java
│   └── target
│       ├── classes
│       ├── generated-sources
│       │   └── annotations
│       ├── generated-test-sources
│       │   └── test-annotations
│       ├── maven-archiver
│       │   └── pom.properties
│       ├── maven-status
│       │   └── maven-compiler-plugin
│       │       ├── compile
│       │       │   └── default-compile
│       │       │       ├── createdFiles.lst
│       │       │       └── inputFiles.lst
│       │       └── testCompile
│       │           └── default-testCompile
│       │               ├── createdFiles.lst
│       │               └── inputFiles.lst
│       ├── module-frontend-1.0-SNAPSHOT
│       │   ├── index.jsp
│       │   ├── META-INF
│       │   │   └── MANIFEST.MF
│       │   ├── web
│       │   │   └── WEB-INF
│       │   │       └── web.xml
│       │   └── WEB-INF
│       │       ├── classes
│       │       ├── lib
│       │       │   ├── angus-activation-2.0.0.jar
│       │       │   ├── antlr4-runtime-4.13.0.jar
│       │       │   ├── byte-buddy-1.14.11.jar
│       │       │   ├── classmate-1.5.1.jar
│       │       │   ├── h2-2.2.224.jar
│       │       │   ├── hibernate-commons-annotations-6.0.6.Final.jar
│       │       │   ├── hibernate-core-6.4.4.Final.jar
│       │       │   ├── istack-commons-runtime-4.1.1.jar
│       │       │   ├── jackson-annotations-2.17.0.jar
│       │       │   ├── jackson-core-2.17.0.jar
│       │       │   ├── jackson-databind-2.17.0.jar
│       │       │   ├── jakarta.activation-api-2.1.0.jar
│       │       │   ├── jakarta.inject-api-2.0.1.jar
│       │       │   ├── jakarta.persistence-api-3.1.0.jar
│       │       │   ├── jakarta.transaction-api-2.0.1.jar
│       │       │   ├── jakarta.xml.bind-api-4.0.0.jar
│       │       │   ├── jandex-3.1.2.jar
│       │       │   ├── jaxb-core-4.0.2.jar
│       │       │   ├── jaxb-runtime-4.0.2.jar
│       │       │   ├── jboss-logging-3.5.0.Final.jar
│       │       │   ├── module-backend-1.0-SNAPSHOT.jar
│       │       │   ├── slf4j-api-2.0.12.jar
│       │       │   ├── slf4j-simple-2.0.12.jar
│       │       │   └── txw2-4.0.2.jar
│       │       └── web.xml
│       ├── module-frontend-1.0-SNAPSHOT.war
│       └── test-classes
├── pom.xml
└── README.md
```

> Hinweis: Die `target`-Ordner enthalten die kompilierten Klassen und WAR-Dateien. Diese werden beim Build erzeugt.

---

## Voraussetzungen

- **Java 17** installiert und als `JAVA_HOME` gesetzt
- **Apache Maven 3.9+** installiert
- **Apache Tomcat 9.x** heruntergeladen und installiert

---

## Setup und Build

1. **Projekt in IntelliJ IDEA öffnen**
    - `File → Open` → wähle den Projektordner `LottoVerwaltung`

2. **Maven Projekte importieren / neu laden**
    - Rechts im Maven-Tool-Fenster → `Reload All Maven Projects`

3. **Prüfen, ob JDK korrekt eingestellt ist**
    - File → Project Structure → Project SDK → **17**
    - File → Project Structure → Modules → Module SDK → **17**

4. **Builden des Projekts**
   ```bash
   mvn clean install
   ```


--- 


## Online Docs und API's

### Apache

[Maven Guides](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html)

[Tomcat 9 Configuration Documentation](https://tomcat.apache.org/tomcat-9.0-doc/config/index.html)

---
### Java

[Java 17 Doc](https://docs.oracle.com/en/java/javase/17/)

[Java EE JSP](https://docs.oracle.com/javaee/5/tutorial/doc/bnajo.html)

[JavaDoc H2 Database](https://javadoc.io/doc/com.h2database/h2/latest/index.html)


---

### Bootstrap

[Java Guides Bootstrap](https://www.javaguides.net/2020/01/add-bootstrap-to-jsp-page.html)



--- 

### API's

[API Doc Tomcat](https://tomcat.apache.org/tomcat-9.0-doc/api/index.html)

[Lotto API](https://lotto-brain.de/eurojackpot-und-lotto-api-offizielle-daten-per-schnittstelle/)

