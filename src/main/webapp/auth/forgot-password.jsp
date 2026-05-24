<%@ page language="java" %>

<html>
<head>
    <title>Forgot Password</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>

<body>

<div class="container">

    <h1>Forgot Your Password?</h1>

    <% if(request.getAttribute("error") != null) { %>
        <p style="color:red;">
            <%= request.getAttribute("error") %>
        </p>
    <% } %>

    <form action="<%= request.getContextPath() %>/ForgotPasswordServlet"
          method="post">

        <input type="text"
               name="username"
               placeholder="Username"
               required>

        <input type="password"
               name="password"
               placeholder="New Password"
               required>

        <input type="password"
               name="confirm"
               placeholder="Confirm Password"
               required>

        <button type="submit">Submit</button>

    </form>

</div>

</body>
</html>