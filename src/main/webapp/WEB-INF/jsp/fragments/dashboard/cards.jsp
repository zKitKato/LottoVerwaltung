<!-- Content Row -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">

    <!-- Euro neachste Ziehung Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="h5 font-weight-bold text-primary text-uppercase mb-1">
                            Eurojackpot
                        </div>
                        <div class=" mb-0 font-weight-bold text-gray-800">
                            Naechste Ziehung: ${gameDrawEuro.nextDeadlineDate}
                            <hr>
                            Jackpot: ${gameDrawEuro.jackpot} Euro
                        </div>


                    </div>
                    <div class="col-auto">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Lotto Naechste Ziehung Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="h5 font-weight-bold text-success text-uppercase mb-1">
                            Lotto
                        </div>
                        <div class="mb-0 font-weight-bold text-gray-800">
                            Naechste Ziehung: ${gameDrawLotto.nextDeadlineDate}
                            <hr>
                            Jackpot: ${gameDrawLotto.jackpot} Euro
                        </div>
                    </div>
                    <div class="col-auto">

                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Euro letzteZiehung Ziehung Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="h5 font-weight-bold text-primary text-uppercase mb-1">
                            Eurojackpot
                        </div>
                        <div class=" mb-0 font-weight-bold text-gray-800">
                            Aktuele Ziehung: ${gameDrawEuro.gameDate}
                            <hr>
                            Zahlen: ${gameDrawEuro.numbers}
                            <hr>
                            Eurozahlen: ${gameDrawEuro.extraNumbers}
                        </div>


                    </div>
                    <div class="col-auto">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Lotto Naechste Ziehung Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="h5 font-weight-bold text-success text-uppercase mb-1">
                            Lotto
                        </div>
                        <div class="mb-0 font-weight-bold text-gray-800">
                            Aktuelle Ziehung: ${gameDrawLotto.gameDate}
                            <hr>
                            Superzahl: ${gameDrawLotto.extraNumbers}
                            <hr>
                            Zahlen: ${gameDrawLotto.numbers}
                        </div>
                    </div>
                    <div class="col-auto">

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>