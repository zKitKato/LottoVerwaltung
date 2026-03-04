<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<h1 class="h3 mb-4 text-gray-800">Spieler Übersicht</h1>


<div class="d-flex justify-content-between mb-3">
    <div>
        <!-- Searchbar -->
        <form method="get"
              action="${pageContext.request.contextPath}/management/player-table"
              class="mb-3">

            <div class="input-group">
                <input type="text"
                       name="keyword"
                       value="${keyword}"
                       class="form-control"
                       placeholder="Spieler:test ....">

                <div class="input-group-append">
                    <button class="btn btn-primary" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
        </form>
    </div>
    <!-- Neuer Button -->
    <button type="button"
            class="btn btn-success"
            data-bs-toggle="modal"
            data-bs-target="#addPlayerModal">
        + Spieler hinzufügen
    </button>
</div>


<!-- ========================= -->
<!-- PLAYER TABLE START -->
<!-- ========================= -->
<div class="card shadow mb-4">
    <div class="card-body">
        <div class="table-responsive">

            <table class="table table-bordered">
                <!-- TABLE HEADER -->
                <thead class="thead-dark">
                <tr>
                    <th>
                        <a href="${pageContext.request.contextPath}/management/player-table?sortField=id&sortDir=${reverseSortDir}&keyword=${keyword}">
                            ID
                            <c:if test="${sortField eq 'id'}">
                                <i class="bi ${sortDir eq 'asc' ? 'bi-arrow-up-short' : 'bi-arrow-down-short'}"></i>
                            </c:if>
                        </a>
                    </th>

                    <th>
                        <a href="${pageContext.request.contextPath}/management/player-table?sortField=username&sortDir=${reverseSortDir}&keyword=${keyword}">
                            Username
                            <c:if test="${sortField eq 'username'}">
                                <i class="bi ${sortDir eq 'asc' ? 'bi-arrow-up-short' : 'bi-arrow-down-short'}"></i>
                            </c:if>
                        </a>
                    </th>

                    <th>
                        <a href="${pageContext.request.contextPath}/management/player-table?sortField=spieltMitSeit&sortDir=${reverseSortDir}&keyword=${keyword}">
                            Spielt seit
                            <c:if test="${sortField eq 'spieltMitSeit'}">
                                <i class="bi ${sortDir eq 'asc' ? 'bi-arrow-up-short' : 'bi-arrow-down-short'}"></i>
                            </c:if>
                        </a>
                    </th>

                    <th>
                        <a href="${pageContext.request.contextPath}/management/player-table?sortField=spiele&sortDir=${reverseSortDir}&keyword=${keyword}">
                            Spiele
                            <c:if test="${sortField eq 'spiele'}">
                                <i class="bi ${sortDir eq 'asc' ? 'bi-arrow-up-short' : 'bi-arrow-down-short'}"></i>
                            </c:if>
                        </a>
                    </th>

                    <th>
                        <a href="${pageContext.request.contextPath}/management/player-table?sortField=kontostand&sortDir=${reverseSortDir}&keyword=${keyword}">
                            Kontostand
                            <c:if test="${sortField eq 'kontostand'}">
                                <i class="bi ${sortDir eq 'asc' ? 'bi-arrow-up-short' : 'bi-arrow-down-short'}"></i>
                            </c:if>
                        </a>
                    </th>

                    <th>
                        <a href="${pageContext.request.contextPath}/management/player-table?sortField=status&sortDir=${reverseSortDir}&keyword=${keyword}">
                            Status
                            <c:if test="${sortField eq 'status'}">
                                <i class="bi ${sortDir eq 'asc' ? 'bi-arrow-up-short' : 'bi-arrow-down-short'}"></i>
                            </c:if>
                        </a>
                    </th>

                    <th class="text-center">Aktionen</th>
                </tr>
                </thead>

                <!-- TABLE BODY -->
                <tbody>
                <c:forEach var="player" items="${players}">
                    <tr>
                        <td>${player.id}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/management/player/${player.id}">
                                    ${player.username}
                            </a>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty player.spieltMitSeit}">
                                    ${player.spieltMitSeit}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${player.spiele}</td>
                        <td>${player.kontostand} €</td>
                        <td>${player.status}</td>
                        <td class="text-center">
                            <!-- EDIT BUTTON -->
                            <button type="button"
                                    class="btn btn-sm btn-outline-primary edit-player-btn"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editPlayerModal"
                                    data-id="${player.id}"
                                    data-username="${player.username}"
                                    data-spieltmitseit="${player.spieltMitSeit}"
                                    data-spiele="${player.spiele}"
                                    data-kontostand="${player.kontostand}"
                                    data-status="${player.status}">
                                <i class="bi bi-pencil-fill"></i>
                            </button>

                            <!-- DELETE BUTTON -->
                            <form method="post"
                                  action="${pageContext.request.contextPath}/management/player/delete/${player.id}"
                                  style="display:inline;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="button"
                                        class="btn btn-sm btn-outline-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal"
                                        onclick="setDeleteId('${player.id}', '${player.username}')">
                                    <i class="bi bi-trash-fill"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>

                <!-- FALLS KEINE SPIELER -->
                <c:if test="${empty players}">
                    <tr>
                        <td colspan="7" class="text-center text-muted">Keine Spieler gefunden</td>
                    </tr>
                </c:if>
                </tbody>
            </table>

        </div>
    </div>
</div>

<!-- ========================= -->
<!-- PLAYER TABLE END -->
<!-- ========================= -->


<!-- ADD PLAYER MODAL -->
<div class="modal fade" id="addPlayerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">

            <form method="post"
                  action="${pageContext.request.contextPath}/management/player/add">
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}"/>

                <div class="modal-header">
                    <h5 class="modal-title">Neuen Spieler anlegen</h5>
                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>
                </div>

                <div class="modal-body">

                    <!-- Username -->
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text"
                               name="username"
                               class="form-control"
                               required>
                    </div>

                    <!-- Spielt mit seit -->
                    <div class="form-group">
                        <label>Spielt mit seit</label>

                        <input type="date"
                               id="spieltMitSeit"
                               name="spieltMitSeit"
                               class="form-control">

                        <button type="button"
                                class="btn btn-sm btn-outline-secondary mt-2"
                                onclick="setToday()">
                            Heute verwenden
                        </button>
                    </div>

                    <!-- Spiele -->
                    <div class="form-group">
                        <label>Spiele</label>
                        <select name="spiele" class="form-control">
                            <option value="Lotto">Nur Lotto</option>
                            <option value="Eurojackpot">Nur Eurojackpot</option>
                            <option value="Lotto,Eurojackpot">Beide</option>
                        </select>
                    </div>

                    <!-- Kontostand -->
                    <div class="form-group">
                        <label>Kontostand (€)</label>
                        <input type="number"
                               step="0.01"
                               name="kontostand"
                               class="form-control"
                               required>
                    </div>

                    <!-- Status -->
                    <div class="form-group">
                        <label>Status</label>
                        <select name="status" class="form-control">
                            <option value="aktiv">Aktiv</option>
                            <option value="pausiert">Pausiert</option>
                            <option value="verlassen">Verlassen</option>
                        </select>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">
                        Speichern
                    </button>
                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">
                        Abbrechen
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>


<!-- EDIT PLAYER MODAL -->
<div class="modal fade" id="editPlayerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" id="editPlayerForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="modal-header">
                    <h5 class="modal-title">Spieler bearbeiten</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" class="form-control" id="editUsername" required>
                    </div>

                    <div class="form-group">
                        <label>Spielt mit seit</label>
                        <input type="date" name="spieltMitSeit" class="form-control" id="editSpieltMitSeit">
                        <button type="button" class="btn btn-sm btn-outline-secondary mt-2"
                                onclick="setEditToday()">Heute verwenden
                        </button>
                    </div>

                    <div class="form-group">
                        <label>Spiele</label>
                        <select name="spiele" class="form-control" id="editSpiele">
                            <option value="Lotto">Nur Lotto</option>
                            <option value="Eurojackpot">Nur Eurojackpot</option>
                            <option value="Lotto,Eurojackpot">Beide</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Kontostand (€)</label>
                        <input type="number" step="0.01" name="kontostand" class="form-control" id="editKontostand"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Status</label>
                        <select name="status" class="form-control" id="editStatus">
                            <option value="aktiv">Aktiv</option>
                            <option value="pausiert">Pausiert</option>
                            <option value="verlassen">Verlassen</option>
                        </select>
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

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const editForm = document.getElementById('editPlayerForm');
    const editModal = document.getElementById('editPlayerModal');

    editModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const id = button.getAttribute('data-id');
        const username = button.getAttribute('data-username');
        const spieltMitSeit = button.getAttribute('data-spieltmitseit');
        const spiele = button.getAttribute('data-spiele');
        const kontostand = button.getAttribute('data-kontostand');
        const status = button.getAttribute('data-status');

        // Dynamische POST-URL für den Spieler
        editForm.action = contextPath + '/management/player/edit/' + id;

        // Werte in die Input-Felder setzen
        document.getElementById('editUsername').value = username;
        document.getElementById('editSpieltMitSeit').value = spieltMitSeit;
        document.getElementById('editSpiele').value = spiele;
        document.getElementById('editKontostand').value = kontostand;
        document.getElementById('editStatus').value = status;
    });

    function setEditToday() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('editSpieltMitSeit').value = today;
    }
</script>


<!-- Einheitliches Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0 rounded-3">

            <form method="post" id="deleteForm">
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}"/>

                <!-- Header im gleichen Stil wie deine Karten -->
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">
                        Spieler löschen
                    </h5>
                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>
                </div>

                <div class="modal-body pt-2">
                    <p class="text-muted mb-0">
                        Möchtest du den Spieler
                        <strong id="deletePlayerName"></strong>
                        wirklich löschen?
                    </p>
                </div>

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

<script>
    function setDeleteId(id, username) {

        // Action URL dynamisch setzen
        document.getElementById("deleteForm").action =
            "${pageContext.request.contextPath}/management/player/delete/" + id;

        // Name im Modal anzeigen
        document.getElementById("deletePlayerName").innerText = username;
    }
</script>

<script>
    function setToday() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('spieltMitSeit').value = today;
    }
</script>
