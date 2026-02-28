<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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


<!-- TABLE -->
<div class="card shadow mb-4">
    <div class="card-body">
        <div class="table-responsive">

            <table class="table table-bordered">
                <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Spielt seit</th>
                    <th>Spiele</th>
                    <th>Kontostand</th>
                    <th>Status</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="player" items="${players}">
                    <tr>
                        <td>${player.id}</td>
                        <td>${player.username}</td>
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
                    </tr>
                </c:forEach>

                <c:if test="${empty players}">
                    <tr>
                        <td colspan="6" class="text-center">Keine Spieler gefunden</td>
                    </tr>
                </c:if>
                </tbody>
            </table>

        </div>
    </div>
</div>

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
                        &times;
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


<script>
    function setToday() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('spieltMitSeit').value = today;
    }
</script>

<script>
    function setToday() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('spieltMitSeit').value = today;
    }
</script>