<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lotto</title>

    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap-utilities.min.css" rel="stylesheet">

    <!-- FontAwesome CSS für Icons -->
    <link href="${pageContext.request.contextPath}/assets/fontawesome-free/css/all.min.css" rel="stylesheet">

    <!-- Eigenes Stylesheet -->
    <link href="${pageContext.request.contextPath}/assets/style.css" rel="stylesheet">
</head>
<body id="page-top">

<div id="wrapper">

    <!-- Sidebar -->
    <%@ include file="../fragments/side-navbar.jsp" %>

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">

            <!-- Topbar -->
            <%@ include file="../fragments/top-navbar.jsp" %>
            <!-- Page Content -->
            <div class="container-fluid">
                <jsp:include page="${contentPage}"/>

            </div>

        </div>
        <!-- Footer -->
        <%@ include file="../fragments/footer.jsp" %>
    </div>

</div>

<!-- JS Scripts -->
<script src="${pageContext.request.contextPath}/assets/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/jquery-easing/jquery.easing.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/toggle.js"></script>

</body>
</html>


<script>
    const contextPath = '${pageContext.request.contextPath}';

    const pages = [
        {name: "Spieler Übersicht", url: "/management/player-table", type: "Seite"},
        {name: "Lotto Ziehungen", url: "/addons/lotto-table", type: "Seite"},
        {name: "Euro Ziehungen", url: "/addons/euro-table", type: "Seite"}
    ];

    const players = [
        <c:forEach var="p" items="${allPlayers}" varStatus="status">
        {
            name: "${p.username}",
            url: "/management/player/${p.id}",
            type: "Spieler"
        }<c:if test="${!status.last}">, </c:if>
        </c:forEach>
    ];

    const allSearchItems = [...pages, ...players];

    const input = document.getElementById("navbarSearch");
    const suggestionBox = document.getElementById("searchSuggestions");

    input.addEventListener("input", function () {
        const value = this.value.toLowerCase();
        suggestionBox.innerHTML = "";

        if (!value) {
            suggestionBox.style.display = "none";
            return;
        }

        const matches = allSearchItems.filter(item => item.name.toLowerCase().includes(value));
        if (matches.length === 0) {
            suggestionBox.style.display = "none";
            return;
        }

        matches.forEach(item => {
            const link = document.createElement("a");
            link.className = "list-group-item list-group-item-action d-flex justify-content-between align-items-center";
            link.textContent = item.name;

            const badge = document.createElement("span");
            badge.className = "badge ms-2 " + (item.type === "Spieler" ? "bg-secondary" : "bg-primary");
            badge.textContent = item.type;

            link.appendChild(badge);

            // Context Path korrekt setzen
            link.href = contextPath + item.url;

            suggestionBox.appendChild(link);
        });

        suggestionBox.style.display = "block";
    });
</script>