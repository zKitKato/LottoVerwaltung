<h1 class="h3 mb-4 text-gray-800">${player.username}</h1>

<div class="row">

    <!-- Kontostand Card -->
    <div class="col-xl-4 col-md-6 mb-4">
        <div class="card shadow h-100 py-2">
            <div class="card-body">
                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                    Kontostand
                </div>

                <div class="h5 mb-0 font-weight-bold
                    ${player.kontostand < 0 ? 'text-danger' : 'text-success'}">
                    ${player.kontostand} €
                </div>
            </div>
        </div>
    </div>

</div>

<!-- Tickets Tabelle -->
<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
            Aktuelle Tippscheine
        </h6>
    </div>

    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered">

                <thead>
                <tr>
                    <th>Spiel</th>
                    <th>Datum</th>
                    <th>Zahlen</th>
                    <th>Extra</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="ticket" items="${tickets}">
                    <tr>
                        <td>${ticket.gameType}</td>
                        <td>${ticket.drawDate}</td>
                        <td>${ticket.numbers}</td>
                        <td>${ticket.extraNumbers}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty tickets}">
                    <tr>
                        <td colspan="4" class="text-center text-muted">Keine Tippscheine vorhanden</td>
                    </tr>
                </c:if>
                </tbody>

            </table>
        </div>
    </div>
</div>