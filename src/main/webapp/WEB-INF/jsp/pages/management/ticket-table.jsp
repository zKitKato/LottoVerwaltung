<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
    :root {
        --lotto-yellow: #ffcc00;
        --lotto-red: #dc3545;
        --lotto-blue: #4a668c;
        --euro-gray: #e9ecef;
    }

    body {
        background-color: #f4f7f6;
    }

    /* LOTTO & EURO GRID STYLES */
    .lotto-grid-container {
        background: white;
        padding: 20px;
        border-radius: 8px;
        border: 1px solid #dee2e6;
        position: relative;
        min-height: 450px;
    }

    .number-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 6px;
        max-width: 350px;
        margin: 0 auto;
        z-index: 2;
        position: relative;
    }

    .euro-grid {
        grid-template-columns: repeat(10, 1fr);
        max-width: 450px;
    }

    .num-box {
        border: 1px solid #f8d7da;
        color: var(--lotto-red);
        aspect-ratio: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-weight: bold;
        transition: 0.2s;
        user-select: none;
        background: white;
    }

    .num-box:hover {
        background-color: #f8d7da;
    }

    .num-box.selected {
        background-color: var(--lotto-red);
        color: white;
        border-color: var(--lotto-red);
    }

    /* STERNE FÜR EUROJACKPOT */
    .star-container {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 15px;
    }

    .star-box {
        width: 40px;
        height: 40px;
        clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
        background-color: #ddd;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-size: 0.8rem;
        font-weight: bold;
    }

    .star-box.selected {
        background-color: #ffc107;
        color: black;
    }

    /* STATUS TEXT */
    #statusLabel {
        font-weight: bold;
        font-size: 1.1rem;
        transition: color 0.3s;
    }

    .status-invalid {
        color: var(--lotto-red);
    }

    .status-valid {
        color: #198754;
    }

    /* REITER / TABS UNTEN */
    .tab-bar {
        display: flex;
        gap: 6px;
        overflow-x: auto;
        padding: 15px 0;
        align-items: center;
    }

    .tab-item {
        min-width: 60px;
        height: 60px;
        background: white;
        border: 1px solid #ccc;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-weight: bold;
    }

    .tab-item.active {
        border: 2px solid var(--lotto-red);
        background-image: radial-gradient(#dee2e6 2px, transparent 2px);
        background-size: 8px 8px;
    }

    .tab-item.filled {
        color: #333;
        border-color: #999;
    }

    /* Beispiel für eine schöne blau-violette Info-Farbe */
    .badge-info-custom {
        background-color: #0dcaf0; /* Ein helles Blau (Bootstrap Info) */
        color: #000 !important; /* Schwarze Schrift für besseren Kontrast auf hellem Blau */
        font-size: 0.7rem;
        padding: 0.4em 0.6em;
    }

    /* Falls du ein dunkleres Blau mit weißer Schrift bevorzugst: */
    .badge-info-custom {
        background-color: #0d6efd; /* Primär Blau */
        color: #ffffff !important; /* Weiße Schrift */
    }

    .placeholder-yellow {
        background-color: var(--lotto-yellow);
        border: none;
        pointer-events: none;
    }
</style>


<h1 class="h3 mb-4 text-gray-800">Ticket Übersicht</h1>

<div class="d-flex justify-content-between mb-3">
    <form method="get" action="${pageContext.request.contextPath}/management/ticket-table" class="d-flex gap-2">
        <div class="input-group">
            <input type="text" name="keyword" value="${keyword}" class="form-control"
                   placeholder="Suche nach Spieler...">
            <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
        </div>
    </form>
    <button type="button" class="btn btn-success shadow-sm" data-bs-toggle="modal" data-bs-target="#addTicketModal">
        <i class="bi bi-plus-lg"></i> Ticket hinzufügen
    </button>
</div>

<div class="card shadow-sm mb-4">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th>Spieler</th>
                    <th>Spieltyp</th>
                    <th>Felder</th>
                    <th>Zusatz</th>
                    <th>Losnummer</th>
                    <th>Gesamtpreis</th>
                    <th>Erstellt am</th>
                    <th class="text-center">Aktionen</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <%-- FALL 1: Tickets sind vorhanden --%>
                    <c:when test="${not empty tickets}">
                        <c:forEach var="ticket" items="${tickets}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/management/player/${ticket.playerId}"
                                       class="text-decoration-none fw-bold">
                                        <i class="bi bi-person-circle"></i> ${ticket.player.username}
                                    </a>
                                </td>
                                <td>
                        <span class="badge ${ticket.gameType eq 'LOTTO' ? 'bg-primary' : 'bg-warning text-dark'}">
                                ${ticket.gameType}
                        </span>
                                </td>
                                <td><span
                                        class="badge rounded-pill bg-light text-dark border">${ticket.fieldCount} Felder</span>
                                </td>
                                <td>
                                    <div class="d-flex gap-1">
                                        <c:if test="${ticket.spiel77}"><span
                                                class="badge badge-info-custom">S77</span></c:if>
                                        <c:if test="${ticket.super6}"><span
                                                class="badge badge-info-custom">S6</span></c:if>
                                        <c:if test="${ticket.gluecksspirale}"><span
                                                class="badge badge-info-custom">GS</span></c:if>
                                        <c:if test="${!ticket.spiel77 && !ticket.super6 && !ticket.gluecksspirale}">-</c:if>
                                    </div>
                                </td>
                                <td><code>${ticket.losnummer}</code></td>
                                <td class="text-nowrap fw-bold">${ticket.totalPrice} €</td>
                                <td><i class="bi bi-calendar3 small"></i> ${ticket.createdAt.toLocalDate()}</td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-outline-primary"
                                                onclick="openEditModal('${ticket.id}', '${ticket.gameType}')">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger"
                                                onclick="confirmDeleteTicket('${ticket.id}', '${ticket.player.username}', '${ticket.gameType}')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>

                    <%-- FALL 2: Liste ist leer --%>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="text-center py-5">
                                <div class="text-muted">
                                    <i class="bi bi-search mb-2" style="font-size: 2.5rem; opacity: 0.5;"></i>
                                    <h5 class="fw-bold">Keine Tickets gefunden</h5>
                                    <p class="mb-0">Es wurden keine Einträge in der Datenbank gefunden oder die Suche
                                        ergab keinen Treffer.</p>
                                    <c:if test="${not empty keyword}">
                                        <a href="${pageContext.request.contextPath}/management/ticket-table"
                                           class="btn btn-sm btn-link mt-2 text-decoration-none">
                                            <i class="bi bi-x-circle"></i> Suche zurücksetzen
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>


<div class="modal fade" id="addTicketModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <form id="lottoForm" method="post" action="${pageContext.request.contextPath}/management/ticket/add">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="fieldsInput" id="fieldsInput">

                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold">Neuen Tippschein anlegen</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body bg-light">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card p-3 mb-3 border-0 shadow-sm">
                                <label class="form-label fw-bold small text-uppercase">Spieler</label>
                                <select name="playerId" class="form-select mb-3" required>
                                    <c:forEach var="player" items="${allPlayers}">
                                        <option value="${player.id}">${player.username}</option>
                                    </c:forEach>
                                </select>

                                <label class="form-label fw-bold small text-uppercase">Spieltyp</label>
                                <select name="gameType" id="gameSelect" class="form-select" onchange="changeGameType()">
                                    <option value="LOTTO">Lotto 6aus49</option>
                                    <option value="EURO">Eurojackpot</option>
                                </select>
                            </div>

                            <div class="card p-3 border-0 shadow-sm mb-3">
                                <h6 class="fw-bold mb-3 small text-uppercase">Zusatzlotterien</h6>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="checkSpiel77" name="spiel77"
                                           onchange="updateCalc()">
                                    <label class="form-check-label" for="checkSpiel77">Spiel 77 (+2,50 €)</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="checkSuper6" name="super6"
                                           onchange="updateCalc()">
                                    <label class="form-check-label" for="checkSuper6">Super 6 (+1,25 €)</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="checkGlueck"
                                           name="gluecksspirale" onchange="updateCalc()">
                                    <label class="form-check-label" for="checkGlueck">Glücksspirale (+5,00 €)</label>
                                </div>
                            </div>

                            <div class="card p-3 border-0 shadow-sm">
                                <label class="form-label fw-bold small text-uppercase">Losnummer</label>
                                <input type="text" name="losnummer" id="losnummer"
                                       class="form-control text-center fw-bold" maxlength="7" placeholder="7-stellig"
                                       value="1234567">
                                <small class="text-muted">Die letzte Ziffer ist die Superzahl.</small>
                            </div>
                        </div>

                        <div class="col-md-8">
                            <div class="lotto-grid-container shadow-sm">
                                <div class="text-center mb-4">
                                    <div id="statusLabel" class="status-invalid">Normal 6aus49</div>
                                    <small class="text-muted" id="instructionText">wählen Sie mind. 6 Zahlen</small>
                                </div>

                                <div class="number-grid" id="mainGrid">
                                </div>

                                <div id="extraGrid" class="star-container d-none">
                                </div>

                                <div class="d-flex justify-content-between mt-4 p-2 border-top">
                                    <button type="button" class="btn btn-outline-secondary btn-sm"
                                            onclick="clearActiveField()">🗑
                                    </button>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-secondary btn-sm" onclick="quickTip()">🎲
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-bar mt-2" id="tabContainer">
                                <div class="tab-item active" id="tab-0" onclick="switchTab(0)">1</div>
                                <div class="tab-item text-muted" id="plusBtn" onclick="addTab()"
                                     style="font-size:1.5rem">+
                                </div>
                                <div class="tab-item placeholder-yellow"></div>
                                <div class="tab-item placeholder-yellow"></div>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-8">
                            <div class="card p-3 border-0 shadow-sm">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label class="small fw-bold">Beginn</label>
                                        <input type="date" name="validFrom" class="form-control" value="2026-03-07">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="small fw-bold">Ziehungen</label>
                                        <select name="drawDay" id="drawDay" class="form-select" onchange="updateCalc()">
                                            <option value="SA">Samstag</option>
                                            <option value="MI">Mittwoch</option>
                                            <option value="BOTH">Mi + Sa</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="small fw-bold">Wochen</label>
                                        <input type="number" name="weeks" id="weeks" class="form-control" value="1"
                                               min="1" oninput="updateCalc()">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card p-3 border-0 shadow-sm bg-dark text-white text-center h-100 d-flex flex-column justify-content-center">
                                <small class="text-uppercase" style="font-size: 0.7rem;">Gesamtpreis</small>
                                <div class="h2 mb-0" id="displayTotalPrice">0,00 €</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="formErrorMessage" class="alert alert-danger d-none mx-3" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <span id="errorText">Ticket kann nicht ohne Inhalt gespeichert werden!</span>
                </div>
                <div class="modal-footer bg-white border-0">
                    <button type="button" class="btn btn-link text-muted text-decoration-none" data-bs-dismiss="modal">
                        Abbrechen
                    </button>
                    <button type="submit" class="btn btn-success px-5 shadow">Ticket Speichern</button>
                </div>
            </form>
        </div>
    </div>
</div>


<div class="modal fade" id="editTicketModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="editTicketForm" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="modal-header">
                    <h5 class="modal-title">Ticket bearbeiten</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Spieler</label>
                            <select name="playerId" id="edit_playerId" class="form-select" required>
                                <c:forEach items="${allPlayers}" var="p">
                                    <option value="${p.id}">${p.username}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Spieltyp</label>
                            <select name="gameType" id="edit_gameType" class="form-select" disabled>
                                <option value="LOTTO">Lotto 6aus49</option>
                                <option value="EURO">Eurojackpot</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Losnummer</label>
                            <input type="text" name="losnummer" id="edit_losnummer" class="form-control" maxlength="7"
                                   required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Gültig ab</label>
                            <input type="date" name="validFrom" id="edit_validFrom" class="form-control" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label d-flex justify-content-between align-items-center">
                                Spielzahlen (Interaktives Grid)
                                <span id="edit_statusLabel" class="status-invalid">Lade...</span>
                            </label>

                            <div class="border p-3 bg-light rounded">
                                <div class="tab-container mb-3" id="edit_tabContainer">
                                    <div id="edit_plusBtn" class="tab-item plus" onclick="addTab(true)">+</div>
                                </div>

                                <div id="edit_mainGrid" class="number-grid mb-3"></div>
                                <div id="edit_extraGrid" class="number-grid euro-grid d-none"></div>

                                <div class="d-flex justify-content-center gap-2 mt-2">
                                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="quickTip()">
                                        Quick-Tipp
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger"
                                            onclick="clearActiveField()">Löschen
                                    </button>
                                </div>
                            </div>
                            <input type="hidden" name="fieldsInput" id="edit_fieldsInput">
                        </div>

                        <div class="col-12 d-flex gap-3">
                            <div class="form-check">
                                <input type="checkbox" name="spiel77" id="edit_spiel77" class="form-check-input">
                                <label class="form-check-label">Spiel 77</label>
                            </div>
                            <div class="form-check">
                                <input type="checkbox" name="super6" id="edit_super6" class="form-check-input">
                                <label class="form-check-label">Super 6</label>
                            </div>
                            <div class="form-check">
                                <input type="checkbox" name="glueck" id="edit_glueck" class="form-check-input">
                                <label class="form-check-label">Glücksspirale</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Abbrechen</button>
                    <button type="submit" class="btn btn-primary">Änderungen speichern</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="deleteTicketModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill"></i> Löschung bestätigen</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Sind Sie sicher, dass Sie den Tippschein von <strong id="deletePlayerName"></strong> (<span
                        id="deleteGameType"></span>) unwiderruflich löschen möchten?</p>
            </div>
            <div class="modal-footer">
                <form id="deleteTicketForm" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Abbrechen</button>
                    <button type="submit" class="btn btn-danger shadow">Ja, jetzt löschen</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const ctx = "${pageContext.request.contextPath}";
    let activeTabIdx = 0;
    let fieldStorage = Array.from({length: 18}, () => ({numbers: new Set(), extras: new Set()}));
    let currentGame = "LOTTO";

    /* INITIALISIERUNG */
    function initGrid() {
        // Findet alle Grids (Add und Edit)
        const mainGrids = document.querySelectorAll('#mainGrid, #edit_mainGrid');
        const extraGrids = document.querySelectorAll('#extraGrid, #edit_extraGrid');

        mainGrids.forEach(grid => {
            grid.innerHTML = '';
            grid.className = (currentGame === "LOTTO") ? "number-grid" : "number-grid euro-grid";
            const max = (currentGame === "LOTTO") ? 49 : 50;
            for (let i = 1; i <= max; i++) createBox(i, grid, false);
        });

        extraGrids.forEach(grid => {
            grid.innerHTML = '';
            if (currentGame === "EURO") {
                grid.classList.remove('d-none');
                for (let i = 1; i <= 12; i++) createBox(i, grid, true);
            } else {
                grid.classList.add('d-none');
            }
        });
        renderSelection();
    }

    function createBox(val, container, isExtra) {
        const div = document.createElement('div');
        div.className = isExtra ? 'star-box' : 'num-box';
        div.innerText = val;
        div.onclick = () => toggleNumber(val, isExtra);
        container.appendChild(div);
    }

    function toggleNumber(val, isExtra) {
        const data = fieldStorage[activeTabIdx];
        const targetSet = isExtra ? data.extras : data.numbers;
        const limit = currentGame === "LOTTO" ? (isExtra ? 0 : 6) : (isExtra ? 2 : 5);

        if (targetSet.has(val)) {
            targetSet.delete(val);
        } else if (targetSet.size < limit) {
            targetSet.add(val);
        }
        renderSelection();
        if (typeof updateCalc === "function") updateCalc();
    }

    function renderSelection() {
        const data = fieldStorage[activeTabIdx];

        // Alle Grids markieren (Add & Edit)
        document.querySelectorAll('.num-box, .star-box').forEach(box => {
            const val = parseInt(box.innerText);
            const isStar = box.classList.contains('star-box');
            const set = isStar ? data.extras : data.numbers;
            box.classList.toggle('selected', set.has(val));
        });

        const isValid = (currentGame === "LOTTO") ? (data.numbers.size === 6) : (data.numbers.size === 5 && data.extras.size === 2);

        // Status Labels aktualisieren
        const labels = document.querySelectorAll('#statusLabel, #edit_statusLabel');
        labels.forEach(l => {
            l.innerText = isValid ? (currentGame + " (OK)") : "Unvollständig";
            l.className = isValid ? "status-valid" : "status-invalid";
        });

        // Tabs markieren
        document.querySelectorAll('#tab-' + activeTabIdx + ', #edit-tab-' + activeTabIdx).forEach(t => {
            t.classList.toggle('filled', isValid);
        });
    }

    /* TABS */
    function switchTab(idx) {
        document.querySelectorAll('.tab-item').forEach(t => t.classList.remove('active'));
        activeTabIdx = idx;
        document.querySelectorAll('#tab-' + idx + ', #edit-tab-' + idx).forEach(t => t.classList.add('active'));
        renderSelection();
    }

    /* SPIELTYP UMSCHALTEN */
    function changeGameType() {
        const select = document.getElementById('gameSelect');
        const drawDaySelect = document.getElementById('drawDay'); // Das Ziehungs-Feld

        if (!select || !drawDaySelect) return;

        currentGame = select.value;

        // Ziehungstage dynamisch anpassen
        if (currentGame === "EURO") {
            drawDaySelect.innerHTML = `
            <option value="FR">Freitag</option>
            <option value="DI">Dienstag</option>
            <option value="BOTH">Di + Fr</option>
        `;
        } else {
            drawDaySelect.innerHTML = `
            <option value="SA">Samstag</option>
            <option value="MI">Mittwoch</option>
            <option value="BOTH">Mi + Sa</option>
        `;
        }

        // Reset der restlichen Logik (wie bisher)
        fieldStorage = Array.from({length: 18}, () => ({numbers: new Set(), extras: new Set()}));
        activeTabIdx = 0;

        const tabs = document.querySelectorAll('.tab-item[id^="tab-"]');
        tabs.forEach((t, idx) => {
            if (idx > 0) t.remove();
        });

        initGrid();
        updateCalc();
    }

    /* WICHTIG: Das Submit für das ADD-Formular fehlte auch noch in deinem Skript */
    document.getElementById('lottoForm').onsubmit = function (e) {
        const completeFields = fieldStorage.filter(f =>
            currentGame === "LOTTO" ? f.numbers.size === 6 : (f.numbers.size === 5 && f.extras.size === 2)
        );

        if (completeFields.length === 0) {
            e.preventDefault();
            alert("Mindestens ein Feld muss vollständig ausgefüllt sein!");
            return false;
        }

        const resultString = completeFields.map(f => {
            const nums = Array.from(f.numbers).sort((a, b) => a - b).join(',');
            if (currentGame === "LOTTO") {
                const los = document.getElementById('losnummer').value;
                return nums + ',' + los.substring(los.length - 1);
            }
            return nums + ';' + Array.from(f.extras).sort((a, b) => a - b).join(',');
        }).join('|');

        document.getElementById('fieldsInput').value = resultString;
        return true;
    };

    function addTab(isEdit = false) {
        const prefix = isEdit ? 'edit-' : '';
        const containerId = isEdit ? 'edit_tabContainer' : 'tab-container';
        const plusBtnId = isEdit ? 'edit_plusBtn' : 'plusBtn';

        const count = document.querySelectorAll('.tab-item[id^="' + prefix + 'tab-"]').length;
        if (count < (currentGame === "LOTTO" ? 18 : 14)) {
            const btn = document.createElement('div');
            btn.className = 'tab-item';
            btn.id = prefix + 'tab-' + count;
            btn.innerText = count + 1;
            btn.onclick = () => switchTab(count);
            document.getElementById(plusBtnId).before(btn);
            switchTab(count);
        }
    }

    /* PREIS BERECHNUNG */
    function updateCalc() {
        // 1. Variablen holen
        const filledFields = fieldStorage.filter(f =>
            currentGame === "LOTTO" ? f.numbers.size === 6 : (f.numbers.size === 5 && f.extras.size === 2)
        ).length;

        const pricePerField = currentGame === "LOTTO" ? 1.20 : 2.00;
        const drawsPerWeek = document.getElementById('drawDay').value === "BOTH" ? 2 : 1;
        const weeks = parseInt(document.getElementById('weeks').value || 1);

        // 2. Kosten für die Felder (Felder * Preis * Ziehungen pro Woche)
        let priceForFields = filledFields * pricePerField * drawsPerWeek;

        // 3. Kosten für Zusatzlotterien (Diese gelten pro Ziehung, unabhängig von der Feldanzahl)
        let extraLotteryPrice = 0;
        if (document.getElementById('checkSpiel77').checked) extraLotteryPrice += 2.50;
        if (document.getElementById('checkSuper6').checked) extraLotteryPrice += 1.25;
        if (document.getElementById('checkGlueck').checked) extraLotteryPrice += 5.00;

        // Zusatzlotterien werden auch pro Ziehung berechnet
        extraLotteryPrice *= drawsPerWeek;

        // 4. Gesamtsumme pro Woche mal Anzahl der Wochen
        const total = (priceForFields + extraLotteryPrice) * weeks;

        // 5. Anzeige aktualisieren
        document.getElementById('displayTotalPrice').innerText = total.toLocaleString('de-DE', {
            style: 'currency',
            currency: 'EUR'
        });

        // 6. WICHTIG: Den Wert in das versteckte Input-Feld schreiben (für den Form-Submit)
        // Wir nutzen den Punkt als Dezimaltrenner für das Backend
        document.getElementById('totalPriceInput').value = total.toFixed(2);
    }

    /* FORM SUBMIT LOGIK */
    document.getElementById('lottoForm').onsubmit = function (e) {
        // Validierung: Mindestens ein Feld muss voll sein
        const completeFields = fieldStorage.filter(f =>
            currentGame === "LOTTO" ? f.numbers.size === 6 : (f.numbers.size === 5 && f.extras.size === 2)
        );

        if (completeFields.length === 0) {
            e.preventDefault();
            alert("Bitte füllen Sie mindestens ein Feld vollständig aus!");
            return false;
        }

        // Daten für das Backend formatieren
        const result = completeFields.map(f => {
            const nums = Array.from(f.numbers).sort((a, b) => a - b).join(',');
            if (currentGame === "LOTTO") {
                // Bei Lotto hängen wir die Superzahl (letzte Stelle Losnummer) an
                const los = document.getElementById('losnummer').value;
                const sz = los.substring(los.length - 1);
                return nums + ',' + sz;
            } else {
                // Bei Eurojackpot: Zahlen;Extras
                const extras = Array.from(f.extras).sort((a, b) => a - b).join(',');
                return nums + ';' + extras;
            }
        }).join('|');

        document.getElementById('fieldsInput').value = result;

        // Sicherheitshalber updateCalc nochmal aufrufen, damit der Preis aktuell ist
        updateCalc();
        return true;
    };

    function confirmDeleteTicket(id, playerName, gameType) {
        // Falls gameType kleingeschrieben ankommt, in Großbuchstaben umwandeln (für den Controller Pfad)
        const type = gameType.toUpperCase();

        document.getElementById('deletePlayerName').innerText = playerName;
        document.getElementById('deleteGameType').innerText = (type === 'LOTTO' ? 'Lotto 6aus49' : 'Eurojackpot');

        const deleteForm = document.getElementById('deleteTicketForm');

        // Sicherstellen, dass der Pfad korrekt ist (keine doppelten //)
        const baseUrl = ctx.endsWith('/') ? ctx.slice(0, -1) : ctx;
        deleteForm.action = baseUrl + "/management/ticket/delete/" + type + "/" + id;

        const modalEl = document.getElementById('deleteTicketModal');
        const deleteModal = bootstrap.Modal.getOrCreateInstance(modalEl);
        deleteModal.show();
    }

    /* EDIT MODAL LOGIK */
    async function openEditModal(id, type) {
        try {
            const response = await fetch(ctx + "/management/ticket/details/" + type + "/" + id);
            const data = await response.json();

            // Formular-Felder
            document.getElementById('editTicketForm').action = ctx + "/management/ticket/edit/" + type + "/" + id;
            document.getElementById('edit_playerId').value = data.playerId;
            document.getElementById('edit_gameType').value = data.type;
            document.getElementById('edit_losnummer').value = data.losnummer;
            if (data.validFrom) document.getElementById('edit_validFrom').value = data.validFrom.split('T')[0];
            document.getElementById('edit_spiel77').checked = data.spiel77;
            document.getElementById('edit_super6').checked = data.super6;
            document.getElementById('edit_glueck').checked = data.gluecksspirale;

            // Speicher & Grids
            currentGame = data.type;
            fieldStorage = Array.from({length: 18}, () => ({numbers: new Set(), extras: new Set()}));

            // Alte Edit-Tabs entfernen
            document.querySelectorAll('.tab-item[id^="edit-tab-"]').forEach(t => t.remove());

            data.fields.forEach((f, idx) => {
                f.numbers.split(',').forEach(n => fieldStorage[idx].numbers.add(parseInt(n.trim())));
                if (f.euroNumbers) f.euroNumbers.split(',').forEach(n => fieldStorage[idx].extras.add(parseInt(n.trim())));

                // Tab erstellen
                const btn = document.createElement('div');
                btn.className = 'tab-item';
                btn.id = 'edit-tab-' + idx;
                btn.innerText = idx + 1;
                btn.onclick = () => switchTab(idx);
                document.getElementById('edit_plusBtn').before(btn);
            });

            initGrid();
            switchTab(0);
            bootstrap.Modal.getOrCreateInstance(document.getElementById('editTicketModal')).show();
        } catch (e) {
            alert("Fehler beim Laden");
        }
    }

    /* SUBMIT */
    document.getElementById('editTicketForm').onsubmit = function (e) {
        const completeFields = fieldStorage.filter(f => currentGame === "LOTTO" ? f.numbers.size === 6 : (f.numbers.size === 5 && f.extras.size === 2));
        if (completeFields.length === 0) {
            e.preventDefault();
            alert("Feld unvollständig!");
            return false;
        }

        const resultString = completeFields.map(f => {
            const nums = Array.from(f.numbers).sort((a, b) => a - b).join(',');
            if (currentGame === "LOTTO") {
                const los = document.getElementById('edit_losnummer').value;
                return nums + ',' + los.substring(los.length - 1);
            }
            return nums + ';' + Array.from(f.extras).sort((a, b) => a - b).join(',');
        }).join('|');

        document.getElementById('edit_fieldsInput').value = resultString;
        return true;
    };

    /* HILFSFUNKTIONEN */
    function quickTip() {
        const data = fieldStorage[activeTabIdx];
        data.numbers.clear();
        data.extras.clear();
        const limitN = currentGame === "LOTTO" ? 6 : 5;
        const maxN = (currentGame === "LOTTO") ? 49 : 50;
        while (data.numbers.size < limitN) data.numbers.add(Math.floor(Math.random() * maxN) + 1);
        if (currentGame === "EURO") while (data.extras.size < 2) data.extras.add(Math.floor(Math.random() * 12) + 1);
        renderSelection();
    }

    function clearActiveField() {
        fieldStorage[activeTabIdx].numbers.clear();
        fieldStorage[activeTabIdx].extras.clear();
        renderSelection();
    }

    window.onload = () => initGrid();
</script>

