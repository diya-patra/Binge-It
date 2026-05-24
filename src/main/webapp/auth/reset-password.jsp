<%@ page language="java" %>

<html>
<head>
    <title>Reset Password</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>

<body>

<div class="container">

    <h1>Reset Password</h1>

    <% if(request.getAttribute("error") != null) { %>
        <p style="color:red;">
            <%= request.getAttribute("error") %>
        </p>
    <% } %>

    <form action="<%= request.getContextPath() %>/ResetPasswordServlet"
          method="post">

        <input type="password"
               name="oldPassword"
               placeholder="Old Password"
               required>

        <input type="password"
               name="newPassword"
               placeholder="New Password"
               required>

        <input type="password"
               name="confirmPassword"
               placeholder="Confirm Password"
               required>

        <button type="submit">Submit</button>

    </form>

</div>

</body>
</html>