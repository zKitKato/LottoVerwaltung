<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Aktuelle Tippscheine</h6>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered table-striped align-middle">
                <thead>
                <tr class="bg-light">
                    <th>Spiel</th>
                    <th>Gültig ab</th>
                    <th>Zahlen</th>
                    <th>Zusatz</th>
                    <th>Preis</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ticket" items="${tickets}">
                    <c:set var="isLotto" value="${empty ticket.drawCount}"/>

                    <c:forEach var="field" items="${ticket.fields}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${isLotto}">
                                        <span class="badge bg-primary">Lotto 6aus49</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-info text-dark">Eurojackpot</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:parseDate value="${ticket.validFrom}" pattern="yyyy-MM-dd" var="pDate"/>
                                <fmt:formatDate value="${pDate}" pattern="dd.MM.yyyy"/>
                            </td>
                            <td>
                                <div class="d-flex gap-1">
                                    <c:forEach var="num" items="${fn:split(field.numbers, ',')}">
                                        <span class="badge border text-dark bg-white shadow-sm"
                                              style="width: 30px;">${num}</span>
                                    </c:forEach>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${isLotto}">
                                        <span class="badge bg-danger rounded-circle shadow-sm">
                                                ${field.superNumber}
                                        </span>
                                        <small class="text-muted ms-1">SZ</small>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="d-flex gap-1">
                                            <c:forEach var="eNum" items="${fn:split(field.euroNumbers, ',')}">
                                                    <span class="badge bg-warning text-dark rounded-circle shadow-sm"
                                                          style="width: 30px;">
                                                            ${eNum}
                                                    </span>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end fw-bold">
                                <fmt:formatNumber value="${ticket.totalPrice}" type="currency" currencySymbol="€"/>
                            </td>
                        </tr>
                    </c:forEach>
                </c:forEach>

                <c:if test="${empty tickets}">
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted">
                            <i class="fas fa-info-circle me-2"></i>Keine Tippscheine für diesen Spieler vorhanden
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>