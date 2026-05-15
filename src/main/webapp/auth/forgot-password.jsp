<%@ page language="java" %>
<html>
<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

<div class="container">
    <h1>Forgot Password</h1>

    <% if (request.getAttribute("msg") != null) { %>
        <p style="color:green;"><%= request.getAttribute("msg") %></p>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/ForgotPasswordServlet" method="post">

        <input type="email" name="email" placeholder="Enter your Email" required />

        <button type="submit">Send Reset Link</button>
    </form>

    <p><a href="login.jsp">Back to Login</a></p>
</div>

</body>
</html>