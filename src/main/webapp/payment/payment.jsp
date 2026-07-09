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
    Double totalAmount = booking.getDouble("total_amount") != null
                         ? booking.getDouble("total_amount") : 0.0;
    List<Document> bookedSeats = booking.getList("booked_seats", Document.class);
    int seatCount = bookedSeats != null ? bookedSeats.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/booking.css">
    <style>
        .payment-card {
            background: var(--clr-white);
            padding: 2.5rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            max-width: 520px;
            margin: 0 auto;
        }
        .payment-order-info {
            background: var(--clr-primary-pale);
            border: 1px solid var(--clr-border);
            border-radius: var(--radius-md);
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
        }
        .payment-order-info p {
            margin: 0.3rem 0;
            font-size: 0.92rem;
            color: var(--clr-text-muted);
        }
        .payment-order-info strong {
            color: var(--clr-text);
        }
        .payment-total {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--clr-primary);
        }
        .payment-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .payment-tab {
            flex: 1;
            padding: 0.6rem;
            text-align: center;
            border: 1.5px solid var(--clr-border);
            border-radius: var(--radius-md);
            cursor: pointer;
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--clr-text-muted);
            transition: all var(--transition);
            background: var(--clr-white);
        }
        .payment-tab.active {
            border-color: var(--clr-primary);
            color: var(--clr-primary);
            background: var(--clr-primary-pale);
        }
        .payment-form-section { display: none; }
        .payment-form-section.active { display: block; }
        .payment-field {
            margin-bottom: 1rem;
        }
        .payment-field label {
            display: block;
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--clr-text);
            margin-bottom: 0.4rem;
        }
        .payment-field input, .payment-field select {
            width: 100%;
            padding: 0.65rem 1rem;
            border: 1.5px solid var(--clr-border);
            border-radius: var(--radius-md);
            font-family: var(--font-main);
            font-size: 1rem;
            color: var(--clr-text);
            outline: none;
            transition: border-color var(--transition);
        }
        .payment-field input:focus, .payment-field select:focus {
            border-color: var(--clr-primary);
        }
        .payment-row {
            display: flex;
            gap: 1rem;
        }
        .payment-row .payment-field {
            flex: 1;
        }
    </style>
</head>
<body>
<jsp:include page="../header.jsp" />

<main>
    <div class="bi-hero">
        <div class="bi-hero__inner">
            <span class="bi-hero__badge">Secure Checkout</span>
            <h1 class="bi-hero__title">Complete Payment</h1>
            <p class="bi-hero__subtitle">Choose your preferred payment method</p>
        </div>
    </div>

    <section class="bi-section">
        <div class="bi-container">
            <div class="payment-card">

                <!-- Order Summary -->
                <div class="payment-order-info">
                    <p>Booking Ref: <strong><%= bookingRef %></strong></p>
                    <p>Seats: <strong><%= seatCount %></strong></p>
                    <p>Total: <span class="payment-total">Rs. <%= totalAmount.intValue() %></span></p>
                </div>

                <!-- Payment Method Tabs -->
                <div class="payment-tabs">
                    <div class="payment-tab active" onclick="switchTab('card', this)">💳 Card</div>
                    <div class="payment-tab" onclick="switchTab('upi', this)">📱 UPI</div>
                    <div class="payment-tab" onclick="switchTab('netbanking', this)">🏦 Net Banking</div>
                </div>

                <!-- Card Form -->
                <form action="<%= request.getContextPath() %>/payment-success"
                      method="post" id="paymentForm">
                    <input type="hidden" name="bookingRef" value="<%= bookingRef %>">
                    <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="Card">

                    <div id="section-card" class="payment-form-section active">
                        <div class="payment-field">
                            <label>Cardholder Name</label>
                            <input type="text" name="cardHolder" placeholder="Your full name" />
                        </div>
                        <div class="payment-field">
                            <label>Card Number</label>
                            <input type="text" name="cardNumber" maxlength="16"
                                   placeholder="1234 5678 9012 3456" />
                        </div>
                        <div class="payment-row">
                            <div class="payment-field">
                                <label>Expiry</label>
                                <input type="text" name="expiry" placeholder="MM/YY" maxlength="5" />
                            </div>
                            <div class="payment-field">
                                <label>CVV</label>
                                <input type="password" name="cvv" placeholder="•••" maxlength="3" />
                            </div>
                        </div>
                    </div>

                    <div id="section-upi" class="payment-form-section">
                        <div class="payment-field">
                            <label>UPI ID</label>
                            <input type="text" name="upiId" placeholder="yourname@upi" />
                        </div>
                    </div>

                    <div id="section-netbanking" class="payment-form-section">
                        <div class="payment-field">
                            <label>Select Bank</label>
                            <select name="bank">
                                <option value="">-- Select Bank --</option>
                                <option>State Bank of India</option>
                                <option>HDFC Bank</option>
                                <option>ICICI Bank</option>
                                <option>Axis Bank</option>
                                <option>Kotak Mahindra Bank</option>
                                <option>Punjab National Bank</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit"
                            class="bi-btn bi-btn--primary bi-btn--block bi-btn--large"
                            style="margin-top: 1rem;">
                        Pay Rs. <%= totalAmount.intValue() %>
                    </button>

                </form>

                <div style="text-align:center; margin-top:1rem;">
                    <a href="<%= request.getContextPath() %>/my-bookings"
                       class="bi-btn bi-btn--outline">
                        Cancel
                    </a>
                </div>

            </div>
        </div>
    </section>
</main>

<jsp:include page="../footer.jsp" />

<script>
    function switchTab(type, el) {
        document.querySelectorAll('.payment-tab').forEach(function(t) {
            t.classList.remove('active');
        });
        document.querySelectorAll('.payment-form-section').forEach(function(s) {
            s.classList.remove('active');
        });
        el.classList.add('active');
        document.getElementById('section-' + type).classList.add('active');
        var methodMap = { card: 'Card', upi: 'UPI', netbanking: 'Net Banking' };
        document.getElementById('paymentMethodInput').value = methodMap[type];
    }
</script>
</body>
</html>