<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BingeIt - Live Database Booking</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/booking.css">
</head>
<body>

<div class="container">

    <div class="user-bar">
        <% if (session.getAttribute("username") != null) { %>
        <div>
            <strong>Welcome, ${sessionScope.name}</strong><br>
            <small>${sessionScope.username} | ${sessionScope.email}</small>
        </div>
        <div style="display: flex; align-items: center; gap: 15px;">
            <span>Role: ${sessionScope.role != null ? sessionScope.role : 'Customer'}</span>
            <a href="<%= request.getContextPath() %>/logout" style="background: #444; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; font-weight: bold; transition: 0.2s;">Logout</a>
        </div>
        <% } else { %>
        <div>
            <strong>Welcome, Guest Explorer</strong><br>
            <small style="color: #aaa;">Log in to securely save your tickets.</small>
        </div>

        <form action="<%= request.getContextPath() %>/login" method="post" style="display: flex; gap: 10px; align-items: center; margin: 0;">
            <input type="email" name="email" placeholder="Email" required
                   style="padding: 8px; border-radius: 4px; border: 1px solid #444; background: #333; color: white; width: 180px;">

            <input type="password" name="password" placeholder="Password" required
                   style="padding: 8px; border-radius: 4px; border: 1px solid #444; background: #333; color: white; width: 150px;">

            <button type="submit" style="background: var(--primary); color: white; padding: 8px 20px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; transition: 0.2s;">
                Login
            </button>

            <div style="font-size: 0.85em; margin-left: 5px; color: #aaa;">
                or <a href="<%= request.getContextPath() %>/signup.jsp" style="color: var(--primary); text-decoration: none; font-weight: bold;">Sign Up</a>
            </div>
        </form>
        <% } %>
    </div>

    <div class="section-box">
        <h3>1. Select a Movie</h3>
        <div id="loadingStatus" style="color: var(--primary);">Loading movies from database...</div>
        <div class="movie-grid" id="movieContainer"></div>
    </div>

    <div class="section-box">
        <h3>2. Select Date & Showtime</h3>
        <p style="margin-bottom: 5px; font-size: 0.9em; color: #aaa;">Note: Weekend showtimes include a ₹50 surcharge per ticket.</p>
        <p style="margin-bottom: 5px; margin-top: 15px;"><strong>Available Dates:</strong></p>
        <div class="selection-list" id="dateContainer"></div>

        <p style="margin-top: 15px; margin-bottom: 5px;"><strong>Available Showtimes:</strong></p>
        <div class="selection-list" id="timeContainer">
            <p style="color: #888;">Please select a date first.</p>
        </div>
    </div>

    <div class="section-box">
        <h3>3. Select Theatre & Seats</h3>
        <p><strong>PVR Cinemas</strong> - Forum Mall, Elgin Road, Kolkata</p>

        <div class="legend">
            <div class="legend-item"><div class="legend-box" style="background: var(--seat-silver)"></div> Silver (₹150)</div>
            <div class="legend-item"><div class="legend-box" style="background: var(--seat-gold)"></div> Gold (₹200)</div>
            <div class="legend-item"><div class="legend-box" style="background: var(--seat-platinum)"></div> Platinum (₹300)</div>
            <div class="legend-item" style="margin-left: 20px;"><div class="legend-box" style="border: 2px solid var(--primary); background: transparent;"></div> Selected</div>
            <div class="legend-item"><div class="legend-box" style="background: var(--seat-booked)"></div> Booked</div>
        </div>

        <div class="screen-curve">Screen 1</div>
        <div class="seat-map" id="seatMap"></div>
    </div>

    <div class="summary-card">
        <h3>Booking Receipt</h3>
        <div class="summary-details">
            <p><span><strong>Movie:</strong></span> <span id="sumMovie">Not Selected</span></p>
            <p><span><strong>Date & Time:</strong></span> <span id="sumDateTime">Not Selected</span></p>
            <p><span><strong>Selected Seats:</strong></span> <span id="sumSeats">None</span></p>
            <p><span><strong>Base Ticket Total:</strong></span> <span>₹<span id="sumBase">0</span></span></p>
            <p><span><strong>Weekend Surcharge:</strong></span> <span>₹<span id="sumSurcharge">0</span></span></p>
            <p style="border-bottom: none; font-size: 1.2em; margin-top: 10px;">
                <span><strong>Total Amount:</strong></span> <strong>₹<span id="sumTotal">0</span></strong>
            </p>
        </div>

        <div class="actions">
            <button class="btn-download" onclick="downloadSummary()">⬇ Download Summary (TXT)</button>
            <button class="btn-submit" onclick="submitBooking()">Confirm Booking</button>
        </div>
    </div>

</div>

<script>
    // Variables initialized empty, will be filled from the Database
    let movieDatabase = [];
    let showtimesDatabase = {};

    const tiers = {
        'A': { name: 'Silver', price: 150, colorClass: 'silver' },
        'B': { name: 'Silver', price: 150, colorClass: 'silver' },
        'C': { name: 'Silver', price: 150, colorClass: 'silver' },
        'D': { name: 'Gold', price: 200, colorClass: 'gold' },
        'E': { name: 'Gold', price: 200, colorClass: 'gold' },
        'F': { name: 'Gold', price: 200, colorClass: 'gold' },
        'G': { name: 'Gold', price: 200, colorClass: 'gold' },
        'H': { name: 'Platinum', price: 300, colorClass: 'platinum' },
        'I': { name: 'Platinum', price: 300, colorClass: 'platinum' },
        'J': { name: 'Platinum', price: 300, colorClass: 'platinum' }
    };

    const weekendSurchargePerTicket = 50;

    let selectedMovie = null;
    let selectedDate = null;
    let selectedTime = null;
    let selectedSeatsArr = [];

    window.onload = () => {
        // Safe fetch with context path
        fetch('<%= request.getContextPath() %>/FetchBookingDataServlet')
            .then(response => response.json())
            .then(data => {
                movieDatabase = data.movies;
                showtimesDatabase = data.showtimes;

                document.getElementById('loadingStatus').style.display = 'none';
                renderMovies();
                renderDates();
                renderSeats();
            })
            .catch(error => {
                console.error('Error fetching database info:', error);
                document.getElementById('loadingStatus').innerText = "Failed to load database content. Ensure server is running.";
            });
    };

    function renderMovies() {
        const container = document.getElementById('movieContainer');
        movieDatabase.forEach(movie => {
            const card = document.createElement('div');
            card.className = 'movie-card';
            // Safe string concatenation
            card.innerHTML = '<h4>' + movie.title + '</h4><p><span class="badge">' + movie.lang + '</span> <span class="badge">' + movie.genre + '</span></p>' +
                '<p style="font-size: 0.8em; color: #aaa;">' + movie.duration + ' | Rating: ' + movie.rating + '</p>';

            card.onclick = () => {
                document.querySelectorAll('.movie-card').forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');
                selectedMovie = movie.title;
                updateSummary();
            };
            container.appendChild(card);
        });
    }

    function renderDates() {
        const container = document.getElementById('dateContainer');
        Object.keys(showtimesDatabase).forEach(dateStr => {
            const pill = document.createElement('div');
            pill.className = 'pill';

            let displayStr = dateStr;
            if (isWeekend(dateStr)) {
                displayStr += " (Weekend)";
            }

            pill.innerText = displayStr;
            pill.onclick = () => {
                document.querySelectorAll('#dateContainer .pill').forEach(p => p.classList.remove('selected'));
                pill.classList.add('selected');
                selectedDate = dateStr;
                selectedTime = null;
                renderTimes(dateStr);
                updateSummary();
            };
            container.appendChild(pill);
        });
    }

    function renderTimes(dateStr) {
        const container = document.getElementById('timeContainer');
        container.innerHTML = '';
        const times = showtimesDatabase[dateStr];

        times.forEach(time => {
            const pill = document.createElement('div');
            pill.className = 'pill';
            pill.innerText = time;
            pill.onclick = () => {
                document.querySelectorAll('#timeContainer .pill').forEach(p => p.classList.remove('selected'));
                pill.classList.add('selected');
                selectedTime = time;
                updateSummary();
            };
            container.appendChild(pill);
        });
    }

    function renderSeats() {
        const seatMap = document.getElementById('seatMap');
        const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
        const seatsPerRow = 12;

        rows.forEach(row => {
            const tierInfo = tiers[row];
            for(let i=1; i<=seatsPerRow; i++) {
                const seat = document.createElement('div');
                seat.className = 'seat ' + tierInfo.colorClass;
                seat.dataset.id = row + i;
                seat.dataset.type = tierInfo.name;
                seat.dataset.price = tierInfo.price;
                // Safe string concatenation
                seat.title = 'Row ' + row + i + ' - ' + tierInfo.name + ' (₹' + tierInfo.price + ')';

                if(Math.random() < 0.15) {
                    seat.classList.add('booked');
                } else {
                    seat.onclick = () => {
                        seat.classList.toggle('selected');
                        updateSelectedSeats();
                    };
                }
                seatMap.appendChild(seat);
            }
        });
    }

    function updateSelectedSeats() {
        const selectedElements = document.querySelectorAll('.seat.selected');
        selectedSeatsArr = Array.from(selectedElements).map(seat => {
            return {
                id: seat.dataset.id,
                type: seat.dataset.type,
                price: parseInt(seat.dataset.price)
            };
        });
        updateSummary();
    }

    function isWeekend(dateStr) {
        if (!dateStr) return false;
        const date = new Date(dateStr);
        const day = date.getDay();
        return day === 0 || day === 6;
    }

    function updateSummary() {
        document.getElementById('sumMovie').innerText = selectedMovie || "Not Selected";

        let dateTimeStr = "Not Selected";
        // Safe string concatenation
        if (selectedDate && selectedTime) dateTimeStr = selectedDate + ' at ' + selectedTime;
        else if (selectedDate) dateTimeStr = selectedDate + ' (Time pending)';
        document.getElementById('sumDateTime').innerText = dateTimeStr;

        const sumSeats = document.getElementById('sumSeats');
        const sumBase = document.getElementById('sumBase');
        const sumSurcharge = document.getElementById('sumSurcharge');
        const sumTotal = document.getElementById('sumTotal');

        if (selectedSeatsArr.length > 0) {
            // Safe string concatenation
            const seatStrings = selectedSeatsArr.map(s => s.id + ' (' + s.type + ')');
            sumSeats.innerText = seatStrings.join(', ');
            const baseTotal = selectedSeatsArr.reduce((total, seat) => total + seat.price, 0);
            sumBase.innerText = baseTotal;

            let surchargeTotal = 0;
            if (isWeekend(selectedDate)) {
                surchargeTotal = selectedSeatsArr.length * weekendSurchargePerTicket;
            }
            sumSurcharge.innerText = surchargeTotal;
            sumTotal.innerText = baseTotal + surchargeTotal;
        } else {
            sumSeats.innerText = 'None';
            sumBase.innerText = '0';
            sumSurcharge.innerText = '0';
            sumTotal.innerText = '0';
        }
    }

    function downloadSummary() {
        if(!selectedMovie || !selectedDate || !selectedTime || selectedSeatsArr.length === 0) {
            alert("Please complete all selections before downloading.");
            return;
        }

        const name = '${sessionScope.name != null ? sessionScope.name : "Guest User"}';
        const email = '${sessionScope.email != null ? sessionScope.email : "Unknown"}';
        const baseTotal = document.getElementById('sumBase').innerText;
        const surcharge = document.getElementById('sumSurcharge').innerText;
        const grandTotal = document.getElementById('sumTotal').innerText;
        // Safe string concatenation
        const seatDetailsList = selectedSeatsArr.map(s => s.id + ' [' + s.type + ' - ₹' + s.price + ']').join('\n  ');

        // Safe string concatenation
        const textContent = "=================================\n" +
            "      MOVIE BOOKING RECEIPT      \n" +
            "=================================\n" +
            "User Details:\n" +
            "Name: " + name + "\n" +
            "Email: " + email + "\n\n" +
            "Booking Details:\n" +
            "Movie: " + selectedMovie + "\n" +
            "Theatre: PVR Cinemas, Kolkata (Screen 1)\n" +
            "Date: " + selectedDate + (isWeekend(selectedDate) ? " (Weekend)" : "") + "\n" +
            "Showtime: " + selectedTime + "\n\n" +
            "Seat Details:\n  " +
            seatDetailsList + "\n\n" +
            "Financials:\n" +
            "Base Ticket Total: ₹" + baseTotal + "\n" +
            "Weekend Surcharge: ₹" + surcharge + "\n" +
            "---------------------------------\n" +
            "GRAND TOTAL:       ₹" + grandTotal + "\n" +
            "=================================\n";

        const blob = new Blob([textContent], { type: 'text/plain' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'Receipt_' + selectedMovie.replace(/\s+/g, '_') + '.txt';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    }

    function submitBooking() {
        if(!selectedMovie || !selectedDate || !selectedTime || selectedSeatsArr.length === 0) {
            alert("Please complete all selections before submitting.");
            return;
        }

        const bookingData = {
            movie: selectedMovie,
            date: selectedDate,
            time: selectedTime,
            seats: selectedSeatsArr,
            totalAmount: document.getElementById('sumTotal').innerText
        };

        // Safe fetch with context path
        fetch('<%= request.getContextPath() %>/CreateBookingServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(bookingData)
        })
            .then(response => {
                if(response.ok) {
                    return response.text();
                }
                throw new Error('Network response was not ok.');
            })
            .then(data => {
                alert(data);
            })
            .catch(error => {
                console.error('There was a problem with the fetch operation:', error);
                alert("There was an error processing your booking. Please try again.");
            });
    }
</script>

</body>
</html>