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
        response.sendRedirect(request.getContextPath() + "/my-bookings");
        return;
    }

    String bookingRef  = booking.getString("booking_reference") != null
                         ? booking.getString("booking_reference") : "N/A";
    String status      = booking.getString("status") != null
                         ? booking.getString("status") : "Confirmed";
    Double totalAmount = booking.getDouble("total_amount") != null
                         ? booking.getDouble("total_amount") : 0.0;

    List<Document> bookedSeats = booking.getList("booked_seats", Document.class);

    StringBuilder seatDetails = new StringBuilder();
    if (bookedSeats != null) {
        for (Document seat : bookedSeats) {
            if (seatDetails.length() > 0) seatDetails.append(", ");
            seatDetails.append(seat.getString("seat_number"));
        }
    }

    Document payment = (Document) booking.get("payment");
    String paymentMethod = (payment != null && payment.getString("payment_method") != null)
                           ? payment.getString("payment_method") : "Card";
    String transactionId = (payment != null && payment.getString("transaction_id") != null)
                           ? payment.getString("transaction_id") : "N/A";
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/booking.css">
    <style>
        .payment-success-icon {
            font-size: 4rem;
            color: #2E7D32;
            text-align: center;
            margin-bottom: 1rem;
        }
        .payment-receipt {
            background: var(--clr-off-white);
            border: 1px solid var(--clr-border-light);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            margin: 1.5rem 0;
        }
        .payment-receipt-row {
            display: flex;
            justify-content: space-between;
            padding: 0.4rem 0;
            font-size: 0.92rem;
            border-bottom: 1px solid var(--clr-border-light);
        }
        .payment-receipt-row:last-child {
            border-bottom: none;
        }
        .payment-receipt-label {
            color: var(--clr-text-muted);
        }
        .payment-receipt-value {
            font-weight: 700;
            color: var(--clr-text);
        }
        .payment-total-row {
            font-size: 1.1rem;
            color: var(--clr-primary) !important;
        }
    </style>
</head>
<body>
<jsp:include page="../header.jsp" />

<main>
    <section class="bi-section">
        <div class="bi-container">
            <div class="booking-summary-card" style="max-width: 560px; margin: 0 auto;">

                <div class="payment-success-icon">&#10004;</div>
                <h2 style="text-align:center; color: #2E7D32; margin-bottom: 0.25rem;">
                    Payment Successful!
                </h2>
                <p style="text-align:center; color: var(--clr-text-muted); margin-bottom: 0;">
                    Your tickets are confirmed. Enjoy your movie!
                </p>

                <div class="payment-receipt">
                    <div class="payment-receipt-row">
                        <span class="payment-receipt-label">Booking Ref</span>
                        <span class="payment-receipt-value" style="color: var(--clr-primary); font-family: monospace;">
                            <%= bookingRef %>
                        </span>
                    </div>
                    <div class="payment-receipt-row">
                        <span class="payment-receipt-label">Booked By</span>
                        <span class="payment-receipt-value"><%= userName %></span>
                    </div>
                    <div class="payment-receipt-row">
                        <span class="payment-receipt-label">Seats</span>
                        <span class="payment-receipt-value"><%= seatDetails.length() > 0 ? seatDetails : "N/A" %></span>
                    </div>
                    <div class="payment-receipt-row">
                        <span class="payment-receipt-label">Payment Method</span>
                        <span class="payment-receipt-value"><%= paymentMethod %></span>
                    </div>
                    <div class="payment-receipt-row">
                        <span class="payment-receipt-label">Transaction ID</span>
                        <span class="payment-receipt-value" style="font-family: monospace; font-size: 0.82rem;">
                            <%= transactionId %>
                        </span>
                    </div>
                    <div class="payment-receipt-row">
                        <span class="payment-receipt-label">Status</span>
                        <span class="bi-badge bi-badge--confirmed"><%= status %></span>
                    </div>
                    <div class="payment-receipt-row payment-total-row">
                        <span class="payment-receipt-label">Total Paid</span>
                        <span class="payment-receipt-value payment-total-row">
                            Rs. <%= totalAmount.intValue() %>
                        </span>
                    </div>
                </div>

                <div class="booking-actions">
                    <button onclick="downloadTicket()" class="bi-btn bi-btn--primary">
                        Download Ticket
                    </button>
                    <a href="<%= request.getContextPath() %>/my-bookings"
                       class="bi-btn bi-btn--outline">
                        My Bookings
                    </a>
                    <a href="<%= request.getContextPath() %>/movies"
                       class="bi-btn bi-btn--outline">
                        Browse Movies
                    </a>
                </div>

            </div>
        </div>
    </section>
</main>

<jsp:include page="../footer.jsp" />

<script>
function downloadTicket() {
    var ticket =
        "========================================\n" +
        "       BINGEIT - BOOKING CONFIRMED      \n" +
        "========================================\n" +
        "Booking Ref    : <%= bookingRef %>\n" +
        "Booked By      : <%= userName %>\n" +
        "Seats          : <%= seatDetails %>\n" +
        "Payment Method : <%= paymentMethod %>\n" +
        "Transaction ID : <%= transactionId %>\n" +
        "Total Paid     : Rs. <%= totalAmount.intValue() %>\n" +
        "Status         : CONFIRMED\n" +
        "========================================\n" +
        "    Thank you for choosing BingeIt!     \n" +
        "========================================";

    var blob = new Blob([ticket], { type: 'text/plain' });
    var link = document.createElement('a');
    link.download = "BingeIt_Ticket_<%= bookingRef %>.txt";
    link.href = window.URL.createObjectURL(blob);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
</script>
</body>
</html>