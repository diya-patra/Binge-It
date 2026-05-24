<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document" %>
<%
    Document movie = (Document) request.getAttribute("movie");

    String  title       = (movie != null && movie.getString("title")       != null) ? movie.getString("title")       : "Movie";
    String  description = (movie != null && movie.getString("description") != null) ? movie.getString("description") : "";
    String  posterUrl   = (movie != null && movie.getString("poster_url")  != null) ? movie.getString("poster_url")  : "";
    Double  ratingVal   = (movie != null && movie.getDouble("rating")      != null) ? movie.getDouble("rating")      : 0.0;
    String  genre       = (movie != null && movie.getString("genre")       != null) ? movie.getString("genre")       : "";
    Integer duration    = (movie != null && movie.getInteger("duration")   != null) ? movie.getInteger("duration")   : 0;
    String  language    = (movie != null && movie.getString("language")    != null) ? movie.getString("language")    : "";
    String  movieId     = (movie != null) ? movie.getObjectId("_id").toString()     : "";

    // Convert 0–10 rating to 0–5 stars
    int filledStars = (int) Math.round(ratingVal / 2.0);
    if (filledStars > 5) filledStars = 5;
    if (filledStars < 0) filledStars = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BingeIt - <%= title %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/movie.css">

    <%-- Dynamic style only for the hero background image, which depends on JSP data --%>
    <style>
        .movie-hero-bg {
            background-image: url('<%= request.getContextPath() %>/<%= posterUrl %>');
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<header class="navbar">
    <div class="logo-circle"></div>
    <nav class="navbar-links">
        <a href="<%= request.getContextPath() %>/home"        class="nav-link">Home</a>
        <a href="<%= request.getContextPath() %>/movies"      class="nav-link active">Movies</a>
        <a href="<%= request.getContextPath() %>/my-bookings" class="nav-link">Bookings</a>
        <a href="<%= request.getContextPath() %>/profile"     class="nav-link">Profile</a>
        <a href="<%= request.getContextPath() %>/support"     class="nav-link">Support</a>
    </nav>
</header>

<!-- MOVIE HERO BANNER -->
<section class="movie-hero">
    <div class="movie-hero-bg"></div>
    <div class="movie-hero-overlay"></div>
</section>

<!-- DETAILS CARD -->
<section class="details-section">
    <div class="details-card">

        <!-- LEFT: Poster + Rating -->
        <div class="left-col">
            <img class="movie-poster-img"
                 src="<%= request.getContextPath() %>/<%= posterUrl %>"
                 alt="<%= title %>">
            <div>
                <p class="rating-label">Ratings</p>
                <div class="stars">
                    <%
                        for (int i = 1; i <= 5; i++) {
                            if (i <= filledStars) {
                    %>
                    <span class="star-filled">&#9733;</span>
                    <%  } else { %>
                    <span class="star-empty">&#9733;</span>
                    <%  } } %>
                </div>
            </div>
        </div>

        <!-- RIGHT: Description + meta tags -->
        <div class="right-col">
            <div class="description-box">
                <h3 class="desc-heading">Description</h3>
                <p class="desc-text"><%= description %></p>
            </div>
            <% if (!genre.isEmpty() || duration > 0 || !language.isEmpty()) { %>
            <div class="meta-row">
                <% if (!genre.isEmpty())    { %><span class="meta-tag"><%= genre %></span><% } %>
                <% if (duration > 0)        { %><span class="meta-tag"><%= duration %> min</span><% } %>
                <% if (!language.isEmpty()) { %><span class="meta-tag"><%= language %></span><% } %>
            </div>
            <% } %>
        </div>

    </div>
</section>

<!-- BOOK NOW -->
<section class="book-section">
    <a href="<%= request.getContextPath() %>/select-show?movieId=<%= movieId %>"
       class="book-btn">Book Now</a>
</section>

<!-- FOOTER -->
<footer class="footer">
    <div class="footer-logo"></div>
    <div class="footer-links">
        <a href="#" class="footer-link">Facebook</a>
        <a href="#" class="footer-link">Instagram</a>
        <a href="#" class="footer-link">Twitter</a>
    </div>
    <p class="footer-copy">&copy; Bing It!. All Rights Reserved.</p>
</footer>

</body>
</html>
