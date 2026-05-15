<%@ page language="java" %>
<%
String userParam = request.getParameter("user");
%>
<html>
<head>
    <title>Reset Password</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

<div class="container">
    <h1>Reset Password</h1>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/ResetPasswordServlet" method="post">

        <input name="username" value="<%= userParam != null ? userParam : "" %>" placeholder="Username" required />
        <input type="password" name="password" placeholder="New Password" required />
        <input type="password" name="confirm" placeholder="Confirm Password" required />

        <button type="submit">Submit</button>
    </form>
</div>

</body>
</html>