<!-- Sidebar -->
<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center justify-content-center"
       href="${pageContext.request.contextPath}/home">
        <div class="sidebar-brand-text mx-3">LottoVerwaltung</div>
    </a>

    <hr class="sidebar-divider my-0">

    <!-- Nav Item - Dashboard -->
    <li class="nav-item active">
        <a class="nav-link" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span>Dashboard</span>
        </a>
    </li>

    <hr class="sidebar-divider">

    <!-- 1 Section of the Sidebar (Interface) -->

    <%@include file="side-navbar-parts/interface-section.jsp" %>

    <hr class="sidebar-divider">

    <!-- 2 Section of the Sidebar (Addons) -->


    <%@include file="side-navbar-parts/addons-section.jsp" %>

    <hr class="sidebar-divider d-none d-md-block">

    <!-- Documentation section-->

    <%@include file="side-navbar-parts/documentation-section.jsp" %>

    <!-- Sidebar Toggler (Sidebar) -->
    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>


</ul>
<!-- End of Sidebar -->