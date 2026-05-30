<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password | BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>
<jsp:include page="../header.jsp" />

<main class="bi-auth-page">
    <div class="bi-auth-card">
        <h1 class="bi-auth-card__title">Reset Password</h1>
        <p class="bi-auth-card__subtitle">Enter your new password below</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="bi-alert bi-alert--error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/reset-password" method="post">
            <!-- token passed from email link -->
            <input type="hidden" name="token"
                   value="<%= request.getParameter("token") != null
                               ? request.getParameter("token") : "" %>" />
            <div class="bi-form-group">
                <label class="bi-label">New Password</label>
                <input type="password" name="newPassword" class="bi-input"
                       placeholder="Enter new password" required />
            </div>
            <div class="bi-form-group">
                <label class="bi-label">Confirm Password</label>
                <input type="password" name="confirmPassword" class="bi-input"
                       placeholder="Confirm new password" required />
            </div>
            <button type="submit" class="bi-btn bi-btn--primary bi-btn--block bi-btn--large">
                Reset Password
            </button>
        </form>

        <div class="bi-auth-card__footer">
            <a href="<%= request.getContextPath() %>/login">Back to Login</a>
        </div>
    </div>
</main>

<jsp:include page="../footer.jsp" />
</body>
</html>