<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>LottoVerwaltung - Login</title>

    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body class="bg-gradient-primary">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-xl-6 col-lg-7 col-md-9">
            <div class="card shadow-lg my-5">
                <div class="card-body p-5">

                    <div class="text-center mb-4">
                        <h1 class="h4 text-gray-900">Login</h1>
                    </div>

                    <!-- Fehleranzeige -->
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            Benutzername oder Passwort ist falsch.
                        </div>
                    </c:if>

                    <!-- Logoutanzeige -->
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success">
                            Sie wurden erfolgreich abgemeldet.
                        </div>
                    </c:if>

                    <!-- LOGIN FORM -->
                    <form action="${pageContext.request.contextPath}/login" method="post">

                        <!-- CSRF TOKEN (WICHTIG!) -->
                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}"/>

                        <div class="form-group mb-3">
                            <input type="text"
                                   name="username"
                                   class="form-control"
                                   placeholder="Benutzername"
                                   required/>
                        </div>

                        <div class="form-group mb-3">
                            <input type="password"
                                   name="password"
                                   class="form-control"
                                   placeholder="Passwort"
                                   required/>
                        </div>

                        <div class="form-group form-check mb-3">
                            <input type="checkbox"
                                   class="form-check-input"
                                   name="remember-me"
                                   id="rememberMe">
                            <label class="form-check-label" for="rememberMe">
                                Angemeldet bleiben
                            </label>
                        </div>

                        <button type="submit"
                                class="btn btn-primary btn-block w-100">
                            Login
                        </button>

                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

</body>
</html>