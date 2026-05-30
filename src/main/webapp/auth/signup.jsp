<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>
<jsp:include page="../header.jsp" />

<main class="bi-auth-page">
    <div class="bi-auth-card">
        <h1 class="bi-auth-card__title">Create Account</h1>
        <p class="bi-auth-card__subtitle">Join BingeIt and start booking</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="bi-alert bi-alert--error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/signup" method="post">
            <div class="bi-form-group">
                <label class="bi-label">Full Name</label>
                <input type="text" name="name" class="bi-input"
                       placeholder="Enter your full name" required />
            </div>
            <div class="bi-form-group">
                <label class="bi-label">Username</label>
                <input type="text" name="username" class="bi-input"
                       placeholder="Choose a username" required />
            </div>
            <div class="bi-form-group">
                <label class="bi-label">Email</label>
                <input type="email" name="email" class="bi-input"
                       placeholder="Enter your email" required />
            </div>
            <div class="bi-form-group">
                <label class="bi-label">Mobile</label>
                <input type="text" name="mobile" class="bi-input"
                       placeholder="Enter your mobile number" required />
            </div>
            <div class="bi-form-group">
                <label class="bi-label">Password</label>
                <input type="password" name="password" class="bi-input"
                       placeholder="Create a password" required />
            </div>
            <div class="bi-form-group">
                <label class="bi-label">Confirm Password</label>
                <input type="password" name="confirm" class="bi-input"
                       placeholder="Confirm your password" required />
            </div>
            <button type="submit" class="bi-btn bi-btn--primary bi-btn--block bi-btn--large">
                Sign Up
            </button>
        </form>

        <div class="bi-auth-card__footer">
            Already a member? <a href="<%= request.getContextPath() %>/login">Login</a>
        </div>
    </div>
</main>

<jsp:include page="../footer.jsp" />
</body>
</html>