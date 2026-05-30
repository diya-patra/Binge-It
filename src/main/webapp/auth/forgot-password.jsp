<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password | BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>
<jsp:include page="../header.jsp" />

<main class="bi-auth-page">
    <div class="bi-auth-card">
        <h1 class="bi-auth-card__title">Forgot Password</h1>
        <p class="bi-auth-card__subtitle">
            Enter your email and we'll send you a reset link
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="bi-alert bi-alert--error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="bi-alert bi-alert--success">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/forgot-password" method="post">
            <div class="bi-form-group">
                <label class="bi-label">Email</label>
                <input type="email" name="email" class="bi-input"
                       placeholder="Enter your registered email" required />
            </div>
            <button type="submit" class="bi-btn bi-btn--primary bi-btn--block bi-btn--large">
                Send Reset Link
            </button>
        </form>

        <div class="bi-auth-card__footer">
            Remembered it? <a href="<%= request.getContextPath() %>/login">Back to Login</a>
        </div>
    </div>
</main>

<jsp:include page="../footer.jsp" />
</body>
</html>