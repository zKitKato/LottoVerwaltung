<%--
  Created by IntelliJ IDEA.
  User: glr
  Date: 20.02.26
  Time: 09:08
  To change this template use File | Settings | File Templates.
--%>
<html>
<head>
  <title>Lotto Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
</head>
<body>

<!-- Top Navbar -->
<jsp:include page="/WEB-INF/jsp/fragments/top-navbar.jsp"/>

<div class="container-fluid">
  <div class="row">

    <!-- Side Navbar -->
    <!--
    <div class="col-md-2 p-0">
      <jsp:include page="/WEB-INF/jsp/fragments/side-navbar.jsp"/>
    </div>
    -->

    <!-- Main Content -->
    <div class="col-md-10 p-4">
      <jsp:include page="${content}"/>
    </div>

  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>