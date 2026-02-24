<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link href="${pageContext.request.contextPath}/assets/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/assets/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body class="bg-gradient-primary">

<div class="container">

    <!-- Outer Row -->
    <div class="row justify-content-center">
        <div class="col-xl-5 col-lg-6 col-md-9">

            <div class="card o-hidden border-0 shadow-lg my-5">
                <div class="card-body p-5">

                    <!-- Login Form -->
                    <div class="text-center mb-4">
                        <h1 class="h4 text-gray-900">Welcome Back!</h1>
                    </div>

                    <!-- Error / Logout Messages -->
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger" role="alert">
                            Invalid username or password
                        </div>
                    </c:if>
                    <c:if test="${not empty param.logout}">
                        <div class="alert alert-success" role="alert">
                            You have been logged out
                        </div>
                    </c:if>

                    <!-- Login Form -->
                    <form class="user" method="post" action="${pageContext.request.contextPath}/login">
                        <div class="form-group">
                            <input type="text" class="form-control form-control-user" name="username"
                                   placeholder="Enter Username..." required>
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-control form-control-user" name="password"
                                   placeholder="Password" required>
                        </div>
                        <button type="submit" class="btn btn-primary btn-user btn-block">Login</button>
                    </form>

                    <hr>

                    <!-- Links -->
                    <div class="text-center">
                        <a class="small" href="${pageContext.request.contextPath}/forgot-password.jsp">Forgot Password?</a>
                    </div>
                    <div class="text-center">
                        <a class="small" href="${pageContext.request.contextPath}/register.jsp">Create an Account!</a>
                    </div>

                </div>
            </div>

        </div>
    </div>

</div>

<!-- Bootstrap JS -->
<script src="${pageContext.request.contextPath}/assets/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/jquery-easing/jquery.easing.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sb-admin-2.min.js"></script>

</body>
</html>