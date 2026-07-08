<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Document booking = (Document) request.getAttribute("booking");

    if (booking == null) {
        response.sendRedirect(request.getContextPath() + "/bookings");
        return;
    }

    String bookingRef  = booking.getString("booking_reference") != null ? booking.getString("booking_reference") : "N/A";
    String status      = booking.getString("status")            != null ? booking.getString("status")            : "Confirmed";
    Double totalAmount = booking.getDouble("total_amount")      != null ? booking.getDouble("total_amount")      : 0.0;
    List<Document> bookedSeats = booking.getList("booked_seats", Document.class);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/booking.css">
</head>
<body>
<jsp:include page="../header.jsp" />

<main>
    <div class="bi-hero">
        <div class="bi-hero__inner">
            <span class="bi-hero__badge">&#10003; Booking Confirmed</span>
            <h1 class="bi-hero__title">You're all set!</h1>
            <p class="bi-hero__subtitle">Your booking has been confirmed successfully</p>
        </div>
    </div>

    <section class="bi-section">
        <div class="bi-container">
            <div class="booking-summary-card">

                <div class="booking-summary-ref">
                    <span class="booking-summary-label">Booking Reference</span>
                    <span class="booking-summary-value"><%= bookingRef %></span>
                </div>

                <div class="booking-summary-ref">
                    <span class="booking-summary-label">Status</span>
                    <span class="bi-badge bi-badge--confirmed"><%= status %></span>
                </div>

                <hr class="bi-divider">

                <h3 style="margin-bottom: 1rem;">Seats Booked</h3>
                <% if (bookedSeats != null) {
                    for (Document seat : bookedSeats) {
                        String seatNumber = seat.getString("seat_number") != null ? seat.getString("seat_number") : "N/A";
                        String seatType   = seat.getString("seat_type")   != null ? seat.getString("seat_type")   : "N/A";
                        Double seatPrice  = seat.getDouble("price")       != null ? seat.getDouble("price")       : 0.0;
                %>
                <div class="booking-seat-row">
                    <span>Seat <%= seatNumber %> (<%= seatType %>)</span>
                    <span>Rs. <%= seatPrice.intValue() %></span>
                </div>
                <% } } %>

                <hr class="bi-divider">

                <div class="booking-summary-total">
                    <span>Total Paid</span>
                    <span>Rs. <%= totalAmount.intValue() %></span>
                </div>

                <div class="booking-actions bi-mt-4">
                    <a href="<%= request.getContextPath() %>/my-bookings"
                       class="bi-btn bi-btn--primary">
                        View My Bookings
                    </a>
                    <a href="<%= request.getContextPath() %>/movies"
                       class="bi-btn bi-btn--outline">
                        Browse More Movies
                    </a>
                </div>

            </div>
        </div>
    </section>
</main>

<jsp:include page="../footer.jsp" />
</body>
</html>