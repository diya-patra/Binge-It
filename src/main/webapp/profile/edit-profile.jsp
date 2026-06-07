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

    if (profileName  == null) profileName  = "N/A";
    if (userEmail    == null) userEmail    = "N/A";
    if (userMobile   == null) userMobile   = "N/A";
    if (userUsername == null) userUsername = "N/A";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/profile.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main>
    <div class="bi-hero">
        <div class="bi-hero__inner">
            <span class="bi-hero__badge">My Account</span>
            <h1 class="bi-hero__title">Edit Profile</h1>
            <p class="bi-hero__subtitle">Update your personal details</p>
        </div>
    </div>

    <section class="bi-section">
        <div class="bi-container">
            <div class="profile-layout">

                <aside class="profile-sidebar">
                    <div class="profile-avatar">
                        <div class="avatar-circle"><%= profileName.substring(0,1).toUpperCase() %></div>
                        <div class="avatar-name"><%= profileName %></div>
                        <div class="avatar-username">@<%= userUsername %></div>
                    </div>
                    <nav class="profile-nav">
                        <a href="<%= request.getContextPath() %>/profile"
                           class="profile-nav__link">
                            &#128100; My Profile
                        </a>
                        <a href="<%= request.getContextPath() %>/edit-profile"
                           class="profile-nav__link profile-nav__link--active">
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
                            <h2 class="profile-section-title">Edit Your Details</h2>

                            <form method="post"
                                  action="<%= request.getContextPath() %>/edit-profile">
                                <div class="profile-info-grid">

                                    <div class="profile-info-item">
                                        <label class="profile-info-label">Full Name</label>
                                        <input type="text" name="name" class="bi-input"
                                               value="<%= profileName.equals("N/A") ? "" : profileName %>"
                                               required />
                                    </div>

                                    <div class="profile-info-item">
                                        <label class="profile-info-label">Username</label>
                                        <input type="text" name="username" class="bi-input"
                                               value="<%= userUsername.equals("N/A") ? "" : userUsername %>"
                                               required />
                                    </div>

                                    <div class="profile-info-item">
                                        <label class="profile-info-label">Email</label>
                                        <input type="text" class="bi-input"
                                               value="<%= userEmail %>" disabled />
                                        <small style="color: var(--clr-text-muted); font-size: 0.8rem;">
                                            Email cannot be changed
                                        </small>
                                    </div>

                                    <div class="profile-info-item">
                                        <label class="profile-info-label">Mobile</label>
                                        <input type="text" name="mobile" class="bi-input"
                                               value="<%= userMobile.equals("N/A") ? "" : userMobile %>"
                                               required />
                                    </div>

                                </div>

                                <div class="profile-actions">
                                    <button type="submit" class="bi-btn bi-btn--primary">
                                        Save Changes
                                    </button>
                                    <a href="<%= request.getContextPath() %>/profile"
                                       class="bi-btn bi-btn--outline">
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