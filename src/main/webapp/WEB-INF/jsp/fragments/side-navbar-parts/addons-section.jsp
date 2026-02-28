<!-- Heading -->
<div class="sidebar-heading">Addons</div>

<!-- Pages Collapse Menu -->
<li class="nav-item">
    <a class="nav-link collapsed"
       href="#"
       data-bs-toggle="collapse"
       data-bs-target="#collapsePages"
       aria-expanded="true"
       aria-controls="collapsePages">
        <i class="fas fa-fw fa-folder"></i>
        <span>Spieldaten</span>
    </a>
    <div id="collapsePages"
         class="collapse"
         aria-labelledby="headingPages"
         data-bs-parent="#accordionSidebar">
        <!-- Screens to implement -->
        <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Lotto-Hesen</h6>
            <a class="collapse-item" href="${pageContext.request.contextPath}/addons/lotto-table">Lotto Tabelle</a>
            <a class="collapse-item" href="${pageContext.request.contextPath}/addons/euro-table">Euro Jackpot
                Tabelle</a>
        </div>
    </div>
</li>