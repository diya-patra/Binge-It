<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BingeIt - Movies</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/movie.css">
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

<!-- PAGE HEADER -->
<section class="page-header">
    <h1>All Movies</h1>
    <p>Explore and book your favourite shows</p>
</section>

<!-- FILTER BAR -->
<%
    String       searchQuery   = (String)       request.getAttribute("searchQuery");
    String       selectedGenre = (String)       request.getAttribute("selectedGenre");
    List<String> genres        = (List<String>) request.getAttribute("genres");
    if (searchQuery   == null) searchQuery   = "";
    if (selectedGenre == null) selectedGenre = "All";
%>
<div class="filter-bar">
    <form method="get" action="<%= request.getContextPath() %>/movies">
        <input
            type="text"
            name="search"
            class="search-input"
            placeholder="Search movies..."
            value="<%= searchQuery %>">

        <select name="genre" class="genre-select">
            <% if (genres != null) {
                for (String g : genres) {
                    String sel = g.equals(selectedGenre) ? "selected" : "";
            %>
            <option value="<%= g %>" <%= sel %>><%= g %></option>
            <%  } } %>
        </select>

        <button type="submit" class="search-btn">Search</button>

        <% if (!searchQuery.isEmpty() || (selectedGenre != null && !selectedGenre.equals("All"))) { %>
        <a href="<%= request.getContextPath() %>/movies" class="clear-btn">Clear</a>
        <% } %>
    </form>
</div>

<!-- RESULTS INFO -->
<%
    List<Document> movieList = (List<Document>) request.getAttribute("movieList");
    int count = (movieList != null) ? movieList.size() : 0;
%>
<div class="results-info">
    <% if (!searchQuery.isEmpty() || (selectedGenre != null && !selectedGenre.equals("All"))) { %>
        Showing <strong><%= count %></strong> result<%= count != 1 ? "s" : "" %>
        <% if (!searchQuery.isEmpty()) { %> for "<strong><%= searchQuery %></strong>"<% } %>
        <% if (selectedGenre != null && !selectedGenre.equals("All")) { %> in <strong><%= selectedGenre %></strong><% } %>
    <% } else { %>
        Showing <strong><%= count %></strong> movie<%= count != 1 ? "s" : "" %>
    <% } %>
</div>

<!-- MOVIE GRID -->
<section class="movies-section">
    <div class="movie-grid">
        <% if (movieList != null && !movieList.isEmpty()) {
            for (Document movie : movieList) {
                String  id          = movie.getObjectId("_id").toString();
                String  title       = movie.getString("title")     != null ? movie.getString("title")     : "Untitled";
                String  poster      = movie.getString("poster_url")!= null ? movie.getString("poster_url"): "";
                String  genre       = movie.getString("genre")     != null ? movie.getString("genre")     : "";
                Integer dur         = movie.getInteger("duration");
                Double  rating      = movie.getDouble("rating");
                int     ratingStars = (rating != null) ? (int) Math.round(rating / 2.0) : 0;
                if (ratingStars > 5) ratingStars = 5;
        %>
        <div class="movie-card"
             onclick="window.location='<%= request.getContextPath() %>/movie-details?id=<%= id %>'">
            <div class="movie-card-img-wrap">
                <img src="<%= request.getContextPath() %>/<%= poster %>" alt="<%= title %>">
            </div>
            <div class="movie-card-info">
                <div class="movie-card-title" title="<%= title %>"><%= title %></div>
                <div class="movie-card-meta">
                    <%= genre %><% if (dur != null && dur > 0) { %> &bull; <%= dur %> min<% } %>
                </div>
                <div class="movie-card-rating">
                    <%
                        for (int i = 1; i <= 5; i++) {
                            if (i <= ratingStars) {
                    %>
                    <span class="star-sm filled">&#9733;</span>
                    <%  } else { %>
                    <span class="star-sm empty">&#9733;</span>
                    <%  } } %>
                </div>
            </div>
        </div>
        <%  }
        } else { %>
        <div class="empty-state">
            <p>No movies found. Try a different search or genre.</p>
        </div>
        <% } %>
    </div>
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
