<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.RequestDispatcher" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LottoVerwaltung</title>
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap-utilities.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/style.css" rel="stylesheet">
</head>
<body id="page-top">

<div id="wrapper" class="d-flex">

    <!-- Sidebar links -->
    <%@ include file="../fragments/side-navbar.jsp" %>

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="flex-grow-1 d-flex flex-column">

        <!-- Topbar -->
        <%@ include file="../fragments/top-navbar.jsp" %>

        <!-- Main Content -->
        <div id="content" class="container-fluid mt-4">
            <%
                // Hier kommt der Content **nur in den Content-Bereich**
                String contentJsp = (String) request.getAttribute("contentPage");
                if (contentJsp != null) {
                    RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/jsp/pages/" + contentJsp);
                    rd.include(request, response);
                } else {
            %>
            <p>Kein Inhalt geladen.</p>
            <%
                }
            %>
        </div>

        <!-- Footer -->
        <%@ include file="../fragments/footer.jsp" %>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/jquery-easing/jquery.easing.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/toggle.js"></script>

</body>
</html>