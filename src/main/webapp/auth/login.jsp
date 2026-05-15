<%@ page language="java" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

<div class="container">
    <h1>Login</h1>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
        <input name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="Password" required />

        <a href="forgot-password.jsp">Forgot Password?</a>

        <button type="submit">Submit</button>
    </form>

    <p>Not a member? <a href="signup.jsp">Register here</a></p>
</div>

</body>
</html>