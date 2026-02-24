<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>Forgot Password</title>
  <link href="${pageContext.request.contextPath}/assets/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="${pageContext.request.contextPath}/assets/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body class="bg-gradient-primary">

<div class="container">

  <div class="row justify-content-center">
    <div class="col-lg-6">

      <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-5">

          <div class="text-center mb-4">
            <h1 class="h4 text-gray-900">Forgot Your Password?</h1>
            <p>Enter your email and we'll send you a link to reset your password!</p>
          </div>

          <form class="user" method="post" action="${pageContext.request.contextPath}/forgot-password">
            <div class="form-group">
              <input type="email" class="form-control form-control-user" name="email"
                     placeholder="Enter Email Address..." required>
            </div>
            <button type="submit" class="btn btn-primary btn-user btn-block">Reset Password</button>
          </form>

          <hr>

          <div class="text-center">
            <a class="small" href="${pageContext.request.contextPath}/register.jsp">Create an Account!</a>
          </div>
          <div class="text-center">
            <a class="small" href="${pageContext.request.contextPath}/login.jsp">Already have an account? Login!</a>
          </div>

        </div>
      </div>

    </div>
  </div>

</div>

<script src="${pageContext.request.contextPath}/assets/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/jquery-easing/jquery.easing.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sb-admin-2.min.js"></script>

</body>
</html>