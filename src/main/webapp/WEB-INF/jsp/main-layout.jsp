<%@ page contentType="text/html;charset=UTF-8" %>
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
    <%@ include file="fragments/side-navbar.jsp" %>

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">

            <!-- Topbar -->
            <%@ include file="fragments/top-navbar.jsp" %>

            <!-- Page Content -->
            <div class="container-fluid">
                <jsp:include page="/WEB-INF/jsp/index.jsp"/>
            </div>

        </div>

        <!-- Footer -->
        <%@ include file="fragments/footer.jsp" %>
    </div>

</div>

<!-- JS Scripts -->
<script src="${pageContext.request.contextPath}/assets/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/jquery-easing/jquery.easing.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/toggle.js"></script>

</body>
</html>