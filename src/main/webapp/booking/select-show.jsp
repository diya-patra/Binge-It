<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List, org.bson.types.ObjectId" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Document movie      = (Document) request.getAttribute("movie");
    List<Document> shows     = (List<Document>) request.getAttribute("shows");
    List<Document> theatres  = (List<Document>) request.getAttribute("theatres");
    List<Document> movies    = (List<Document>) request.getAttribute("movies");
    String movieId      = (String) request.getAttribute("movieId");

    String movieTitle = (movie != null && movie.getString("title") != null)
                        ? movie.getString("title") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Show - BingeIt</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/booking.css">
</head>
<body>
<jsp:include page="../header.jsp" />

<main>
    <div class="bi-hero">
        <div class="bi-hero__inner">
            <span class="bi-hero__badge">Book Tickets</span>
            <h1 class="bi-hero__title">
                <%= movieTitle.isEmpty() ? "Select a Movie" : "Shows for " + movieTitle %>
            </h1>
            <p class="bi-hero__subtitle">Choose your preferred show and theatre</p>
        </div>
    </div>

    <section class="bi-section">
        <div class="bi-container">

            <%-- If no movie selected yet, show movie selection --%>
            <% if (movieId == null || movieId.isEmpty()) { %>
            <h2 class="bi-section__title" style="margin-bottom:1.5rem;">Select a Movie</h2>
            <div class="bi-movie-grid">
                <% if (movies != null) {
                    for (Document m : movies) {
                        String mId     = m.getObjectId("_id").toString();
                        String mTitle  = m.getString("title") != null ? m.getString("title") : "Untitled";
                        String mPoster = m.getString("poster_url") != null ? m.getString("poster_url") : "";
                        String mGenre  = m.getString("genre") != null ? m.getString("genre") : "";
                %>
                <div class="bi-movie-card"
                     onclick="window.location='<%= request.getContextPath() %>/bookings?movieId=<%= mId %>'">
                    <img class="bi-movie-card__poster"
                         src="<%= request.getContextPath() %>/<%= mPoster %>"
                         alt="<%= mTitle %>">
                    <div class="bi-movie-card__info">
                        <div class="bi-movie-card__title"><%= mTitle %></div>
                        <div class="bi-movie-card__meta"><%= mGenre %></div>
                    </div>
                </div>
                <% } } %>
            </div>

            <%-- Movie selected — show shows grouped by theatre --%>
            <% } else { %>
            <% if (shows == null || shows.isEmpty()) { %>
            <div class="bi-alert bi-alert--warning">
                No shows available for this movie right now.
            </div>
            <a href="<%= request.getContextPath() %>/movies"
               class="bi-btn bi-btn--outline bi-mt-2">
                Back to Movies
            </a>
            <% } else { %>

            <%-- Group shows by theatre --%>
            <% if (theatres != null) {
                for (Document theatre : theatres) {
                    String theatreId   = theatre.getObjectId("_id").toString();
                    String theatreName = theatre.getString("name") != null ? theatre.getString("name") : "";
                    String theatreAddr = theatre.getString("address") != null ? theatre.getString("address") : "";
                    boolean hasShows   = false;

                    for (Document show : shows) {
                        if (show.getObjectId("theatre_id") != null &&
                            show.getObjectId("theatre_id").toString().equals(theatreId)) {
                            hasShows = true;
                            break;
                        }
                    }

                    if (!hasShows) continue;
            %>
            <div class="booking-theatre-card">
                <div class="booking-theatre-header">
                    <h3 class="booking-theatre-name">&#127916; <%= theatreName %></h3>
                    <p class="booking-theatre-address">&#128205; <%= theatreAddr %></p>
                </div>
                <div class="booking-shows-list">
                    <% for (Document show : shows) {
                        if (show.getObjectId("theatre_id") == null ||
                            !show.getObjectId("theatre_id").toString().equals(theatreId)) continue;

                        String showId      = show.getObjectId("_id").toString();
                        String showTime    = show.getString("show_time") != null ? show.getString("show_time") : "";
                        String screenName  = show.getString("screen_name") != null ? show.getString("screen_name") : "";
                        Object showDateObj = show.get("show_date");
                        String showDate    = showDateObj != null ? showDateObj.toString().substring(0, 10) : "";

                        Object priceObj    = show.get("price_silver");
                        String priceFrom   = priceObj instanceof Number
                                             ? "Rs. " + ((Number)priceObj).intValue()
                                             : "Rs. 150";
                    %>
                    <div class="booking-show-slot"
                         onclick="window.location='<%= request.getContextPath() %>/seat-selection?showId=<%= showId %>'">
                        <div class="booking-show-time"><%= showTime %></div>
                        <div class="booking-show-meta"><%= screenName %> &bull; <%= showDate %></div>
                        <div class="booking-show-price">from <%= priceFrom %></div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } } %>
            <% } %>
            <% } %>

        </div>
    </section>
</main>

<jsp:include page="../footer.jsp" />
</body>
</html>