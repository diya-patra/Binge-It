<%@ page language="java" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

<div class="container">
    <h1>Login</h1>

    <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
        <input type="text" name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="Password" required />

        <a href="<%= request.getContextPath() %>/ForgotPasswordServlet">Forgot Password?</a>

        <button type="submit">Submit</button>
    </form>

    <p>Not a member? <a href="signup.jsp">Register here</a></p>
</div>

</body>
</html>