<form class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search position-relative"
      onsubmit="return handleSearch(event)">

    <div class="input-group">
        <input type="text"
               id="navbarSearch"
               class="form-control bg-light border-0 small"
               placeholder="Seite suchen..."
               autocomplete="off">

        <div class="input-group-append">
            <button class="btn btn-primary" type="submit">
                <i class="fas fa-search fa-sm"></i>
            </button>
        </div>
    </div>

    <!-- Vorschlagsliste -->
    <div id="searchSuggestions"
         class="list-group position-absolute w-100 shadow"
         style="z-index: 999; display: none;"></div>
</form>



