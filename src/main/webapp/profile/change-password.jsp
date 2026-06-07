<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/profile.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main>
    <div class="bi-hero">
        <div class="bi-hero__inner">
            <span class="bi-hero__badge">My Account</span>
            <h1 class="bi-hero__title">Change Password</h1>
            <p class="bi-hero__subtitle">Keep your account secure</p>
        </div>
    </div>

    <section class="bi-section">
        <div class="bi-container">
            <div class="profile-layout">

                <aside class="profile-sidebar">
                    <nav class="profile-nav">
                        <a href="<%= request.getContextPath() %>/profile"
                           class="profile-nav__link">
                            &#128100; My Profile
                        </a>
                        <a href="<%= request.getContextPath() %>/edit-profile"
                           class="profile-nav__link">
                            &#9998; Edit Profile
                        </a>
                        <a href="<%= request.getContextPath() %>/my-bookings"
                           class="profile-nav__link">
                            &#127916; My Bookings
                        </a>
                        <a href="<%= request.getContextPath() %>/change-password"
                           class="profile-nav__link profile-nav__link--active">
                            &#128274; Change Password
                        </a>
                        <a href="<%= request.getContextPath() %>/logout"
                           class="profile-nav__link profile-nav__link--danger">
                            &#128682; Logout
                        </a>
                    </nav>
                </aside>

                <div class="profile-content">
                    <div class="bi-card">
                        <div class="bi-card__body">
                            <h2 class="profile-section-title">Change Your Password</h2>

                            <% if (error != null) { %>
                            <div class="bi-error-msg"><%= error %></div>
                            <% } %>

                            <form method="post"
                                  action="<%= request.getContextPath() %>/change-password">

                                <div class="profile-info-grid">
                                    <div class="profile-info-item">
                                        <label class="profile-info-label">Current Password</label>
                                        <input type="password" name="currentPassword"
                                               class="bi-input" required />
                                    </div>
                                    <div class="profile-info-item">
                                        <label class="profile-info-label">New Password</label>
                                        <input type="password" name="newPassword"
                                               class="bi-input" required />
                                    </div>
                                    <div class="profile-info-item">
                                        <label class="profile-info-label">Confirm New Password</label>
                                        <input type="password" name="confirmPassword"
                                               class="bi-input" required />
                                    </div>
                                </div>

                                <div class="profile-actions">
                                    <button type="submit" class="bi-btn bi-btn--primary">
                                        Update Password
                                    </button>
                                    <a href="<%= request.getContextPath() %>/profile"
                                       class="bi-btn bi-btn--primary-outline">
                                        Cancel
                                    </a>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>
</main>

<jsp:include page="../footer.jsp" />

</body>
</html>