<!-- Topbar -->
<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

    <!-- Topbar Search -->
    
    <%@include file="top-navbar-parts/search-bar.jsp" %>

    <!-- Topbar Navbar -->
    <ul class="navbar-nav ml-auto">

        <!-- Alerts -->

        <%@include file="top-navbar-parts/alerts.jsp" %>

        <div class="topbar-divider d-none d-sm-block"></div>

        <!-- User Information -->

        <%@ include file="top-navbar-parts/user-Information.jsp" %>

    </ul>

</nav>
<!-- End of Topbar -->