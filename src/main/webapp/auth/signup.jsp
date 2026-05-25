<%@ page language="java" %>
<html>
<head>
    <title>Signup</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

<div class="container">
    <h1>Sign Up</h1>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/SignupServlet" method="post">

        <input name="name" placeholder="Name" required />
        <input name="username" placeholder="Username" required />
        <input name="email" placeholder="Email" required />
        <input name="mobile" placeholder="Mobile No." required />

        <input type="password" name="password" placeholder="Password" required />
        <input type="password" name="confirm" placeholder="Confirm Password" required />

        <button type="submit">Submit</button>
    </form>

    <p>Already a member? <a href="login.jsp">Login here</a></p>
</div>

</body>
</html>