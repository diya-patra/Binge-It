<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List, java.util.Set" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Document show    = (Document) request.getAttribute("show");
    Document theatre = (Document) request.getAttribute("theatre");
    Document movie   = (Document) request.getAttribute("movie");
    List<Document> allSeats     = (List<Document>) request.getAttribute("allSeats");
    Set<String> bookedSeatIds   = (Set<String>) request.getAttribute("bookedSeatIds");
    String showId    = (String) request.getAttribute("showId");

    String movieTitle   = (movie   != null && movie.getString("title")   != null) ? movie.getString("title")   : "Movie";
    String theatreName  = (theatre != null && theatre.getString("name")  != null) ? theatre.getString("name")  : "Theatre";
    String showTime     = (show    != null && show.getString("show_time") != null) ? show.getString("show_time") : "";
    String screenName   = (show    != null && show.getString("screen_name") != null) ? show.getString("screen_name") : "";

    int priceSilver   = 150, priceGold = 250, pricePlatinum = 400;
    if (show != null) {
        if (show.get("price_silver")   instanceof Number) priceSilver   = ((Number) show.get("price_silver")).intValue();
        if (show.get("price_gold")     instanceof Number) priceGold     = ((Number) show.get("price_gold")).intValue();
        if (show.get("price_platinum") instanceof Number) pricePlatinum = ((Number) show.get("price_platinum")).intValue();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Seats - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/booking.css">
</head>
<body>
<jsp:include page="../header.jsp" />

<main>
    <div class="bi-hero">
        <div class="bi-hero__inner">
            <span class="bi-hero__badge">Select Seats</span>
            <h1 class="bi-hero__title"><%= movieTitle %></h1>
            <p class="bi-hero__subtitle">
                <%= theatreName %> &bull; <%= screenName %> &bull; <%= showTime %>
            </p>
        </div>
    </div>

    <section class="bi-section">
        <div class="bi-container">

            <!-- Screen -->
            <div class="booking-screen-wrap">
                <div class="booking-screen"></div>
                <p class="booking-screen-label">SCREEN</p>
            </div>

            <!-- Legend -->
            <div class="booking-legend">
                <div class="booking-legend-item">
                    <div class="booking-legend-box seat-silver"></div>
                    <span>Silver — Rs. <%= priceSilver %></span>
                </div>
                <div class="booking-legend-item">
                    <div class="booking-legend-box seat-gold"></div>
                    <span>Gold — Rs. <%= priceGold %></span>
                </div>
                <div class="booking-legend-item">
                    <div class="booking-legend-box seat-platinum"></div>
                    <span>Platinum — Rs. <%= pricePlatinum %></span>
                </div>
                <div class="booking-legend-item">
                    <div class="booking-legend-box seat-selected"></div>
                    <span>Selected</span>
                </div>
                <div class="booking-legend-item">
                    <div class="booking-legend-box seat-booked"></div>
                    <span>Booked</span>
                </div>
            </div>

            <!-- Seat Grid -->
            <div class="booking-seat-grid">
                <% if (allSeats != null) {
                    for (Document seat : allSeats) {
                        String seatId     = seat.getObjectId("_id").toString();
                        String seatNumber = seat.getString("seat_number") != null ? seat.getString("seat_number") : "";
                        String seatType   = seat.getString("seat_type")   != null ? seat.getString("seat_type")   : "Silver";
                        boolean isBooked  = bookedSeatIds != null && bookedSeatIds.contains(seatId);

                        int seatPrice = seatType.equals("Gold") ? priceGold
                                      : seatType.equals("Platinum") ? pricePlatinum
                                      : priceSilver;

                        String cssClass = "booking-seat seat-" + seatType.toLowerCase();
                        if (isBooked) cssClass += " seat-booked";
                %>
                <div class="<%= cssClass %>"
                     data-id="<%= seatId %>"
                     data-price="<%= seatPrice %>"
                     data-number="<%= seatNumber %>"
                     <%= isBooked ? "" : "onclick=\"toggleSeat(this)\"" %>>
                    <%= seatNumber %>
                </div>
                <% } } %>
            </div>

            <!-- Total -->
            <div class="booking-total">
                Selected: <span id="selectedCount">0</span> seat(s) |
                Total: <strong>Rs. <span id="totalAmount">0</span></strong>
            </div>

            <!-- Form -->
            <form action="<%= request.getContextPath() %>/create-booking" method="post"
                  id="bookingForm">
                <input type="hidden" name="showId" value="<%= showId %>">
                <div id="seatInputs"></div>
                <div class="booking-actions">
                    <a href="<%= request.getContextPath() %>/bookings?movieId=<%= movie != null ? movie.getObjectId("_id").toString() : "" %>"
                       class="bi-btn bi-btn--outline">
                        Back
                    </a>
                    <button type="submit" class="bi-btn bi-btn--primary"
                            onclick="return validateSeats()">
                        Confirm Booking
                    </button>
                </div>
            </form>

        </div>
    </section>
</main>

<jsp:include page="../footer.jsp" />

<script>
    var selectedSeats = [];
    var totalAmount   = 0;

    function toggleSeat(el) {
        var seatId    = el.getAttribute('data-id');
        var price     = parseInt(el.getAttribute('data-price'));
        var number    = el.getAttribute('data-number');

        if (el.classList.contains('seat-selected')) {
            el.classList.remove('seat-selected');
            selectedSeats = selectedSeats.filter(function(s) { return s.id !== seatId; });
            totalAmount  -= price;
        } else {
            el.classList.add('seat-selected');
            selectedSeats.push({ id: seatId, number: number, price: price });
            totalAmount += price;
        }

        document.getElementById('selectedCount').innerText = selectedSeats.length;
        document.getElementById('totalAmount').innerText   = totalAmount;

        // Update hidden inputs
        var container = document.getElementById('seatInputs');
        container.innerHTML = '';
        selectedSeats.forEach(function(s) {
            var input = document.createElement('input');
            input.type  = 'hidden';
            input.name  = 'seatIds';
            input.value = s.id;
            container.appendChild(input);
        });
    }

    function validateSeats() {
        if (selectedSeats.length === 0) {
            alert('Please select at least one seat.');
            return false;
        }
        return true;
    }
</script>
</body>
</html>