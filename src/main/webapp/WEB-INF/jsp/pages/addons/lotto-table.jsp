<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h1 class="h3 mb-4 text-gray-800">Lotto Ziehungen</h1>

<div class="card shadow mb-4">
    <div class="card-body">
        <div class="table-responsive">

            <table class="table table-bordered">
                <thead class="thead-dark">
                <tr>
                    <th>Datum</th>
                    <th>Tag</th>
                    <th>Zahlen</th>
                    <th>Superzahl</th>
                    <th>Jackpot</th>
                    <th>Nächste Frist</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="draw" items="${gameLotto}">
                    <tr>
                        <td>${draw.gameDate}</td>
                        <td>${draw.drawDay}</td>
                        <td>${draw.numbers}</td>
                        <td>${draw.extraNumbers}</td>
                        <td>${draw.jackpot} €</td>
                        <td>${draw.nextDeadlineDate} ${draw.nextDeadlineTime}</td>
                    </tr>
                </c:forEach>
                </tbody>

            </table>

        </div>
    </div>
</div>