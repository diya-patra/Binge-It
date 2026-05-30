<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>
<jsp:include page="../header.jsp" />

<main class="bi-auth-page">
    <div class="bi-auth-card">
        <h1 class="bi-auth-card__title">Welcome Back</h1>
        <p class="bi-auth-card__subtitle">Login to your BingeIt account</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="bi-alert bi-alert--error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="bi-form-group">
                <label class="bi-label">Email</label>
                <input type="email" name="email" class="bi-input"
                       placeholder="Enter your email" required />
            </div>
            <div class="bi-form-group">
                <label class="bi-label">Password</label>
                <input type="password" name="password" class="bi-input"
                       placeholder="Enter your password" required />
            </div>
            <div class="bi-mb-2" style="text-align:right;">
                <a href="<%= request.getContextPath() %>/forgot-password"
                   style="font-size:0.88rem; color:var(--clr-primary);">
                   Forgot Password?
                </a>
            </div>
            <button type="submit" class="bi-btn bi-btn--primary bi-btn--block bi-btn--large">
                Login
            </button>
        </form>

        <div class="bi-auth-card__footer">
            Not a member? <a href="<%= request.getContextPath() %>/signup">Sign Up</a>
        </div>
    </div>
</main>

<jsp:include page="../footer.jsp" />
</body>
</html>