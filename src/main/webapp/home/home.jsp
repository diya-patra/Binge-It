<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BingeIt - Home</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/home.css">
</head>
<body>
<jsp:include page="../header.jsp" />

<!-- HERO BANNER -->
<section class="hero-banner">
    <div class="hero-overlay">
        <div class="discount-badge">
            <div class="badge-stars">
                <span class="s big">&#9733;</span>
                <span class="s med">&#9733;</span>
                <span class="s sml">&#9733;</span>
            </div>
            <div class="badge-circle">
                <span class="badge-pct">40%</span>
                <span class="badge-off">OFF</span>
            </div>
        </div>
        <div>
            <h1 class="hero-title">Binge It!!!</h1>
            <p class="hero-subtitle">Book your favourite seats now</p>
        </div>
    </div>
</section>

<!-- RECOMMENDED MOVIES -->
<%
    List<Document> recommendedMovies = (List<Document>) request.getAttribute("recommendedMovies");
%>
<section class="movies-section">
    <div class="section-header">
        <h2 class="section-title">Recommended Movies</h2>
        <a href="<%= request.getContextPath() %>/movies" class="see-all">See All &gt;</a>
        
    </div>
    <div class="movie-grid">
        <% if (recommendedMovies != null && !recommendedMovies.isEmpty()) {
            for (Document movie : recommendedMovies) {
                String movieId = movie.getObjectId("_id").toString();
                String title   = movie.getString("title");
                String poster  = movie.getString("poster_url") != null ? movie.getString("poster_url") : "";
        %>
        <div class="movie-card"
             onclick="window.location='<%= request.getContextPath() %>/movie-details?id=<%= movieId %>'">
         
           
            <img src="<%= request.getContextPath() %>/<%= poster %>" alt="<%= title %>">
            
        </div>
        <%  }
        } else { %>
        <p class="no-movies">No movies found.</p>
        <% } %>
    </div>
</section>

<!-- ROMANTIC MOVIES -->
<%
    List<Document> romanticMovies = (List<Document>) request.getAttribute("romanticMovies");
    if (romanticMovies != null && !romanticMovies.isEmpty()) {
%>
<section class="movies-section">
    <div class="section-header">
        <h2 class="section-title">Romantic</h2>
    </div>
    <div class="movie-grid">
        <% for (Document movie : romanticMovies) {
            String movieId = movie.getObjectId("_id").toString();
            String title   = movie.getString("title");
            String poster  = movie.getString("poster_url") != null ? movie.getString("poster_url") : "";
        %>
        <div class="movie-card"
             onclick="window.location='<%= request.getContextPath() %>/movie-details?id=<%= movieId %>'">
           	
           	 <img src="<%= request.getContextPath() %>/<%= poster %>" alt="<%= title %>">
        </div>
        <% } %>
    </div>
</section>
<% } %>

<!-- ACTION MOVIES -->
<%
    List<Document> actionMovies = (List<Document>) request.getAttribute("actionMovies");
    if (actionMovies != null && !actionMovies.isEmpty()) {
%>
<section class="movies-section">
    <div class="section-header">
        <h2 class="section-title">Action</h2>
    </div>
    <div class="movie-grid">
        <% for (Document movie : actionMovies) {
            String movieId = movie.getObjectId("_id").toString();
            String title   = movie.getString("title");
            String poster  = movie.getString("poster_url") != null ? movie.getString("poster_url") : "";
        %>
        <div class="movie-card"
             onclick="window.location='<%= request.getContextPath() %>/movie-details?id=<%= movieId %>'">
           
            <img src="<%= request.getContextPath() %>/<%= poster %>" alt="<%= title %>">
        </div>
        <% } %>
    </div>
</section>
<% } %>

<jsp:include page="../footer.jsp" />

</body>
</html>
