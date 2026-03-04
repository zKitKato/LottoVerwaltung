<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<h1 class="h3 mb-4 text-gray-800">Ticket Übersicht</h1>

<div class="d-flex justify-content-between mb-3">

    <!-- Search -->
    <form method="get"
          action="${pageContext.request.contextPath}/management/ticket-table"
          class="w-50">
        <div class="input-group">
            <input type="text"
                   name="keyword"
                   value="${keyword}"
                   class="form-control"
                   placeholder="Spieler suchen...">
            <button class="btn btn-primary" type="submit">
                <i class="bi bi-search"></i>
            </button>
        </div>
    </form>

    <!-- Add Button -->
    <button type="button"
            class="btn btn-success"
            data-bs-toggle="modal"
            data-bs-target="#addTicketModal">
        + Ticket hinzufügen
    </button>
</div>

<!-- ========================= -->
<!-- TICKET TABLE -->
<!-- ========================= -->

<div class="card shadow mb-4">
    <div class="card-body">
        <div class="table-responsive">

            <table class="table table-bordered align-middle">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Spieler</th>
                    <th>Spiel</th>
                    <th>Zahlen</th>
                    <th>Extra-Zahlen</th>
                    <th>Felder</th>
                    <th>Preis/Feld</th>
                    <th>Gesamtpreis</th>
                    <th>Spieldatum</th>
                    <th class="text-center">Aktionen</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="ticket" items="${tickets}">
                    <tr>
                        <td>${ticket.id}</td>

                        <td>
                            <a href="${pageContext.request.contextPath}/management/player/${ticket.player.id}">
                                    ${ticket.player.username}
                            </a>
                        </td>

                        <td>${ticket.gameType}</td>

                        <!-- Zahlen -->
                        <td>
                            <c:forEach var="field" items="${ticket.fields}" varStatus="s">
                                ${field.numbers}
                                <c:if test="${!s.last}"> | </c:if>
                            </c:forEach>
                        </td>

                        <!-- Extra -->
                        <td>
                            <c:forEach var="field" items="${ticket.fields}" varStatus="s">
                                ${field.extraNumber}
                                <c:if test="${!s.last}"> | </c:if>
                            </c:forEach>
                        </td>

                        <td>${ticket.fields.size()}</td>

                        <td>
                            <c:choose>
                                <c:when test="${ticket.gameType eq 'Lotto'}">1,20 €</c:when>
                                <c:when test="${ticket.gameType eq 'Eurojackpot'}">2,00 €</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td>${ticket.totalPrice} €</td>

                        <!-- WICHTIG: drawDate -->
                        <td>${ticket.drawDate}</td>

                        <!-- ACTIONS -->
                        <td class="text-center">

                            <!-- EDIT -->
                            <button type="button"
                                    class="btn btn-sm btn-outline-primary edit-ticket-btn"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editTicketModal"
                                    data-id="${ticket.id}"
                                    data-player="${ticket.player.id}"
                                    data-game="${ticket.gameType}"
                                    data-playdate="${ticket.drawDate}"
                                    data-fields="<c:forEach var='f' items='${ticket.fields}' varStatus='st'>${f.numbers},${f.extraNumber}<c:if test='${!st.last}'>;</c:if></c:forEach>">
                                <i class="bi bi-pencil-fill"></i>
                            </button>

                            <!-- DELETE -->
                            <form method="post"
                                  action="${pageContext.request.contextPath}/management/ticket/delete/${ticket.id}"
                                  style="display:inline;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="button"
                                        class="btn btn-sm btn-outline-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteTicketModal"
                                        onclick="setDeleteTicket(
                                                '${ticket.id}',
                                                '${ticket.player.username}',
                                                '${ticket.drawDate}'
                                                )">
                                    <i class="bi bi-trash-fill"></i>
                                </button>
                            </form>

                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty tickets}">
                    <tr>
                        <td colspan="10" class="text-center text-muted">
                            Keine Tickets gefunden
                        </td>
                    </tr>
                </c:if>

                </tbody>
            </table>

        </div>
    </div>
</div>


<!-- ========================= -->
<!-- ADD TICKET MODAL -->
<!-- ========================= -->
<div class="modal fade" id="addTicketModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/management/ticket/add">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="modal-header">
                    <h5 class="modal-title">Neues Ticket anlegen</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group mb-3">
                        <label>Spieler</label>
                        <select name="playerId" class="form-control" required>
                            <c:forEach var="player" items="${allPlayers}">
                                <option value="${player.id}">${player.username}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label>Spiel</label>
                        <select name="gameType" class="form-control" id="addGame" required
                                onchange="updateAddExtraNumbers()">
                            <option value="Lotto">Lotto</option>
                            <option value="Eurojackpot">Eurojackpot</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label>Anzahl Felder</label>
                        <input type="number" name="fieldCount" id="addFieldCount" class="form-control" min="1" value="1"
                               required>
                        <small class="text-muted" id="fieldHint">Lotto: 6 Zahlen (1-49) + 1 Superzahl (1-12) </small>
                    </div>

                    <div class="form-group mb-3">
                        <label>Zahlen & Extra-Zahlen</label>
                        <textarea name="fieldsInput" class="form-control" rows="3" placeholder="1,2,3,4,5,6;0"
                                  required></textarea>
                        <small class="text-muted">Trenne Zahlen durch Komma, Felder durch Semikolon. Extra-Zahl ans Ende
                            des Feldes.</small>
                    </div>

                    <!-- Spieldatum (FEHLTE → WAR URSACHE FÜR 400) -->
                    <div class="form-group mb-3">
                        <label>Spieldatum</label>
                        <input type="date"
                               id="playDateInput"
                               name="playDate"
                               class="form-control"
                               required>

                        <button type="button"
                                class="btn btn-sm btn-outline-secondary mt-2"
                                onclick="setToday()">
                            Heute verwenden
                        </button>
                    </div>

                    <div class="form-group mb-3">
                        <label>Gesamtpreis</label>
                        <input type="text" id="addTotalPrice" class="form-control" disabled value="0 €">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Speichern</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Abbrechen</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- ========================= -->
<!-- Einheitliches Delete Ticket Modal -->
<!-- ========================= -->
<div class="modal fade" id="deleteTicketModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0 rounded-3">

            <form method="post" id="deleteTicketForm">
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}"/>

                <!-- Header -->
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">
                        Ticket löschen
                    </h5>
                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>
                </div>

                <!-- Body -->
                <div class="modal-body pt-2">
                    <p class="text-muted mb-0">
                        Möchtest du das Ticket von
                        <strong id="deleteTicketPlayer"></strong>
                        vom
                        <strong id="deleteTicketDate"></strong>
                        wirklich löschen?
                    </p>
                </div>

                <!-- Footer -->
                <div class="modal-footer border-0">
                    <button type="button"
                            class="btn btn-outline-secondary"
                            data-bs-dismiss="modal">
                        Abbrechen
                    </button>

                    <button type="submit"
                            class="btn btn-outline-danger">
                        Löschen
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>

<!-- ========================= -->
<!-- SCRIPT -->
<!-- ========================= -->
<script>
    const addGame = document.getElementById('addGame');
    const fieldCount = document.getElementById('addFieldCount');
    const totalPriceInput = document.getElementById('addTotalPrice');
    const fieldHint = document.getElementById('fieldHint');

    function updateAddExtraNumbers() {
        const game = addGame.value;
        fieldHint.innerText = game === 'Lotto'
            ? 'Lotto: 6 Zahlen (1-49) + 1 Superzahl'
            : 'Eurojackpot: 5 Zahlen (1-50) + 2 Eurozahlen';
        updateTotalPrice();
    }

    function updateTotalPrice() {
        const count = parseInt(fieldCount.value || 1);
        const pricePerField = addGame.value === 'Lotto' ? 1.2 : 2;
        totalPriceInput.value = (count * pricePerField).toFixed(2) + ' €';
    }

    addGame.addEventListener('change', updateTotalPrice);
    fieldCount.addEventListener('input', updateTotalPrice);
    updateTotalPrice();
</script>

<script>
    function setDeleteTicket(id, username, drawDate) {

        // Action URL dynamisch setzen
        document.getElementById("deleteTicketForm").action =
            "${pageContext.request.contextPath}/management/ticket/delete/" + id;

        // Spielername einsetzen
        document.getElementById("deleteTicketPlayer").innerText = username;

        // Datum einsetzen
        document.getElementById("deleteTicketDate").innerText = drawDate;
    }
</script>

<script>
    function setToday() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('playDateInput').value = today;
    }
</script>