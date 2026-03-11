---
id: frontend-communication
title: Kommunikation zwischen Controller und View
sidebar_label: Frontend Kommunikation
---

# Daten-Kommunikation: Vom Controller zur Tabelle

In diesem Kapitel wird am praktischen Beispiel der Eurojackpot-Tabelle erklärt, wie Daten aus der Java-Logik (Backend)
in die HTML-Oberfläche (Frontend) fließen. Dieser Prozess folgt dem klassischen **Model-View-Controller (MVC)** Muster.

---

## 1. Die Datenquelle: Java Backend

Bevor eine Tabelle im Browser angezeigt werden kann, muss der `ViewController` die Daten bereitstellen. Dies geschieht
in zwei Schritten: Laden der Daten und Übergabe an das `Model`.

### Beispiel: Der Controller-Auszug

```java

@GetMapping("/addons/{page}")
public String loadAddon(@PathVariable String page, Model model) {
    if ("euro-table".equals(page)) {
        // 1. Daten über das Repository aus der H2-Datenbank abrufen
        List<GameDrawEuro> draws = gameDrawEuroRepository.findAll();

        // 2. Daten unter dem Namen "gameEuro" für das Frontend registrieren
        model.addAttribute("gameEuro", draws);
    }

    model.addAttribute("contentPage", "/WEB-INF/jsp/pages/addons/" + page + ".jsp");
    return "layout/main-layout";
}
```

Was hier passiert:

gameDrawEuroRepository.findAll() holt eine Liste von Objekten des Typs GameDrawEuro aus der Datenbank.

model.addAttribute("gameEuro", draws) fungiert als "Transportkorb". Die Daten werden unter dem Schlüssel "gameEuro"
gespeichert, damit die JSP-Seite sie später identifizieren kann.

---

2. Die Darstellung: JSP Frontend
   Im Frontend wird die JSTL (JSP Standard Tag Library) genutzt, um die Java-Daten dynamisch in HTML zu transformieren.

Beispiel: Das JSP-Snippet

```HTML

<div class="card shadow mb-4">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="thead-dark">
                <tr>
                    <th>Datum</th>
                    <th>Tag</th>
                    <th>Zahlen</th>
                    <th>Jackpot</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="draw" items="${gameEuro}">
                    <tr>
                        <td>${draw.gameDate}</td>
                        <td>${draw.drawDay}</td>
                        <td>${draw.numbers}</td>
                        <td>${draw.jackpot} €</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
```

---

3. Funktionsweise der Kommunikation (Deep Dive)
   Der Datenaustausch basiert auf drei Mechanismen:

A. Die forEach-Schleife (`<c:forEach>`)
Das Attribut items="${gameEuro}" greift auf die Liste zu, die der Controller zuvor in das Model gelegt hat. Mit var="
draw" wird für jedes Objekt in der Liste ein lokaler Name vergeben, der innerhalb der Schleife gültig ist.

B. Expression Language (EL)
Ausdrücke wie ${draw.gameDate} sind keine direkten Datenbankaufrufe. Die JSP-Engine nutzt Reflection, um automatisch die
entsprechende Getter-Methode im Java-Model aufzurufen (in diesem Fall getGameDate()).

C. Server-Side Rendering
Wichtig zu verstehen ist, dass die Schleife auf dem Server ausgeführt wird. Der Browser erhält kein JSP-Code, sondern
ein fertiges, reines HTML-Dokument, in dem die Daten bereits fest in die Tabellenzellen eingebettet sind.

---

| Phase         | Akteur     | Was passiert hier?                                                                                               |
|:--------------|:-----------|:-----------------------------------------------------------------------------------------------------------------|
| **Request**   | Browser    | Der Benutzer löst durch eine Aktion (Klick) eine Anfrage aus.                                                    |
| **Logik**     | Controller | Die Daten werden aus der Datenbank gesammelt und in das Model "gepackt".                                         |
| **Rendering** | JSP-Engine | Der Server "liest" die Anweisungen im HTML, entnimmt die Daten aus dem Model und baut die finale Seite zusammen. |
| **Response**  | Browser    | Der Benutzer sieht das fertige Ergebnis als reine HTML-Tabelle.                                                  |