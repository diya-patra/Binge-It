<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Document> bookings = (List<Document>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/profile.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main>
    <div class="bi-hero">
        <div class="bi-hero__inner">
            <span class="bi-hero__badge">My Account</span>
            <h1 class="bi-hero__title">My Bookings</h1>
            <p class="bi-hero__subtitle">Your movie booking history</p>
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
                           class="profile-nav__link profile-nav__link--active">
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
                            <h2 class="profile-section-title">Booking History</h2>

                            <% if (bookings == null || bookings.isEmpty()) { %>
                            <div style="text-align:center; padding: 2rem 0;">
                                <p style="color: var(--clr-text-muted); margin-bottom: 1rem;">
                                    You have no bookings yet.
                                </p>
                                <a href="<%= request.getContextPath() %>/movies"
                                   class="bi-btn bi-btn--primary">
                                    Browse Movies
                                </a>
                            </div>
                            <% } else { %>
                            <div class="bookings-list">
                                <% for (Document booking : bookings) {
                                    String bookingRef  = booking.getString("booking_reference") != null
                                                         ? booking.getString("booking_reference") : "N/A";
                                    String status      = booking.getString("status") != null
                                                         ? booking.getString("status") : "Pending";
                                    Double totalAmount = booking.getDouble("total_amount") != null
                                                         ? booking.getDouble("total_amount") : 0.0;
                                    List<Document> bookedSeats = booking.getList("booked_seats", Document.class);
                                    int seatCount = bookedSeats != null ? bookedSeats.size() : 0;
                                    String badgeClass = status.equalsIgnoreCase("Confirmed") ? "bi-badge--confirmed"
                                                      : status.equalsIgnoreCase("Cancelled") ? "bi-badge--cancelled"
                                                      : "bi-badge--pending";
                                %>
                                <div class="booking-card">
                                    <div class="booking-info">
                                        <h3 class="booking-movie">Ref: <%= bookingRef %></h3>
                                        <p class="booking-detail">Seats Booked: <%= seatCount %></p>
                                        <p class="booking-detail">Total Paid: Rs. <%= totalAmount %></p>
                                    </div>
                                    <div class="booking-status">
                                        <span class="bi-badge <%= badgeClass %>"><%= status %></span>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                            <% } %>

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