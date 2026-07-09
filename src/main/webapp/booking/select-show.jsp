<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List, org.bson.types.ObjectId" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Document movie         = (Document) request.getAttribute("movie");
    List<Document> shows   = (List<Document>) request.getAttribute("shows");
    List<Document> theatres= (List<Document>) request.getAttribute("theatres");
    List<Document> movies  = (List<Document>) request.getAttribute("movies");
    String movieId         = (String) request.getAttribute("movieId");

    String movieTitle = (movie != null && movie.getString("title") != null)
                        ? movie.getString("title") : "";

    // Helper: get movie title by ObjectId from movies list
    // Used when showing all shows (navbar mode)
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Tickets - BingeIt</title>
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
                <%= movieTitle.isEmpty() ? "Now Showing" : "Shows for " + movieTitle %>
            </h1>
            <p class="bi-hero__subtitle">
                <%= movieTitle.isEmpty() ? "Select a show to book your seats" : "Choose your preferred show and theatre" %>
            </p>
        </div>
    </div>

    <section class="bi-section">
        <div class="bi-container">

            <% if (shows == null || shows.isEmpty()) { %>
            <div class="bi-alert bi-alert--warning">
                No shows available right now.
            </div>
            <a href="<%= request.getContextPath() %>/movies"
               class="bi-btn bi-btn--outline bi-mt-2">
                Browse Movies
            </a>

            <% } else if (movieId != null && !movieId.isEmpty()) { %>
            <%-- BOOK NOW MODE — shows for specific movie grouped by theatre --%>
            <% if (theatres != null) {
                for (Document theatre : theatres) {
                    String theatreId   = theatre.getObjectId("_id").toString();
                    String theatreName = theatre.getString("name") != null ? theatre.getString("name") : "";
                    String theatreAddr = theatre.getString("address") != null ? theatre.getString("address") : "";
                    boolean hasShows   = false;
                    for (Document show : shows) {
                        if (show.getObjectId("theatre_id") != null &&
                            show.getObjectId("theatre_id").toString().equals(theatreId)) {
                            hasShows = true; break;
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
                        String showId     = show.getObjectId("_id").toString();
                        String showTime   = show.getString("show_time") != null ? show.getString("show_time") : "";
                        String screenName = show.getString("screen_name") != null ? show.getString("screen_name") : "";
                        Object priceObj   = show.get("price_silver");
                        String priceFrom  = priceObj instanceof Number
                                            ? "Rs. " + ((Number)priceObj).intValue() : "Rs. 150";
                    %>
                    <div class="booking-show-slot"
                         onclick="window.location='<%= request.getContextPath() %>/seat-selection?showId=<%= showId %>'">
                        <div class="booking-show-time"><%= showTime %></div>
                        <div class="booking-show-meta"><%= screenName %></div>
                        <div class="booking-show-price">from <%= priceFrom %></div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } } %>

            <% } else { %>
            <%-- NAVBAR MODE — all shows grouped by movie --%>
            <% if (movies != null) {
                for (Document m : movies) {
                    String mId    = m.getObjectId("_id").toString();
                    String mTitle = m.getString("title") != null ? m.getString("title") : "Untitled";
                    String mGenre = m.getString("genre") != null ? m.getString("genre") : "";
                    String mPoster= m.getString("poster_url") != null ? m.getString("poster_url") : "";

                    boolean hasShows = false;
                    for (Document show : shows) {
                        if (show.getObjectId("movie_id") != null &&
                            show.getObjectId("movie_id").toString().equals(mId)) {
                            hasShows = true; break;
                        }
                    }
                    if (!hasShows) continue;
            %>
            <div class="booking-theatre-card">
                <div class="booking-theatre-header" style="display:flex; gap:1rem; align-items:center;">
                    <img src="<%= request.getContextPath() %>/<%= mPoster %>"
                         style="width:60px; height:85px; object-fit:cover; border-radius:6px;">
                    <div>
                        <h3 class="booking-theatre-name"><%= mTitle %></h3>
                        <p class="booking-theatre-address"><%= mGenre %></p>
                    </div>
                </div>
                <div class="booking-shows-list" style="margin-top:1rem;">
                    <% for (Document show : shows) {
                        if (show.getObjectId("movie_id") == null ||
                            !show.getObjectId("movie_id").toString().equals(mId)) continue;
                        String showId     = show.getObjectId("_id").toString();
                        String showTime   = show.getString("show_time") != null ? show.getString("show_time") : "";
                        String screenName = show.getString("screen_name") != null ? show.getString("screen_name") : "";

                        // Find theatre name
                        String tName = "";
                        if (show.getObjectId("theatre_id") != null && theatres != null) {
                            for (Document t : theatres) {
                                if (t.getObjectId("_id").toString().equals(
                                        show.getObjectId("theatre_id").toString())) {
                                    tName = t.getString("name") != null ? t.getString("name") : "";
                                    break;
                                }
                            }
                        }
                        Object priceObj  = show.get("price_silver");
                        String priceFrom = priceObj instanceof Number
                                           ? "Rs. " + ((Number)priceObj).intValue() : "Rs. 150";
                    %>
                    <div class="booking-show-slot"
                         onclick="window.location='<%= request.getContextPath() %>/seat-selection?showId=<%= showId %>'">
                        <div class="booking-show-time"><%= showTime %></div>
                        <div class="booking-show-meta"><%= tName %> &bull; <%= screenName %></div>
                        <div class="booking-show-price">from <%= priceFrom %></div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } } %>
            <% } %>

        </div>
    </section>
</main>

<jsp:include page="../footer.jsp" />
</body>
</html>