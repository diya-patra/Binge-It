<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String profileName  = (String) request.getAttribute("userName");
    String userEmail    = (String) request.getAttribute("userEmail");
    String userMobile   = (String) request.getAttribute("userMobile");
    String userUsername = (String) request.getAttribute("userUsername");

    if (profileName  == null || profileName.trim().isEmpty())  profileName  = "N/A";
    if (userEmail    == null)  userEmail    = "N/A";
    if (userMobile   == null)  userMobile   = "N/A";
    if (userUsername == null)  userUsername = "N/A";

    String avatarLetter = (!profileName.equals("N/A")) ? profileName.substring(0,1).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/profile.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main>
    <div class="bi-hero">
        <div class="bi-hero__inner">
            <span class="bi-hero__badge">My Account</span>
            <h1 class="bi-hero__title">Hello, <%= profileName %>!</h1>
            <p class="bi-hero__subtitle">Manage your profile and bookings</p>
        </div>
    </div>

    <section class="bi-section">
        <div class="bi-container">
            <div class="profile-layout">

                <aside class="profile-sidebar">
                    <div class="profile-avatar">
                        <div class="avatar-circle"><%= avatarLetter %></div>
                        <div class="avatar-name"><%= profileName %></div>
                        <div class="avatar-username">@<%= userUsername %></div>
                    </div>
                    <nav class="profile-nav">
                        <a href="<%= request.getContextPath() %>/profile"
                           class="profile-nav__link profile-nav__link--active">
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
                           class="profile-nav__link">
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
                            <h2 class="profile-section-title">Profile Details</h2>

                            <div class="profile-info-grid">
                                <div class="profile-info-item">
                                    <span class="profile-info-label">Full Name</span>
                                    <span class="profile-info-value"><%= profileName %></span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="profile-info-label">Username</span>
                                    <span class="profile-info-value">@<%= userUsername %></span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="profile-info-label">Email</span>
                                    <span class="profile-info-value"><%= userEmail %></span>
                                </div>
                                <div class="profile-info-item">
                                    <span class="profile-info-label">Mobile</span>
                                    <span class="profile-info-value"><%= userMobile %></span>
                                </div>
                            </div>

                            <div class="profile-actions">
                                <a href="<%= request.getContextPath() %>/edit-profile"
                                   class="bi-btn bi-btn--primary">
                                    Edit Profile
                                </a>
                                <a href="<%= request.getContextPath() %>/my-bookings"
                                   class="bi-btn bi-btn--outline">
                                    My Bookings
                                </a>
                                <a href="<%= request.getContextPath() %>/change-password"
                                   class="bi-btn bi-btn--outline">
                                    Change Password
                                </a>
                            </div>

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