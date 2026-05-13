<%@ page language="java" %>
<html>
<head>
    <title>Reset Password</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

<div class="container">
    <h1>Reset Password</h1>

    <form action="<%= request.getContextPath() %>/ResetPasswordServlet" method="post">

        <input type="text" name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="New Password" required />
        <input type="password" name="confirm" placeholder="Confirm Password" required />

        <button type="submit">Submit</button>
    </form>

</div>

</body>
</html>