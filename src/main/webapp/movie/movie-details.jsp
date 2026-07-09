<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document" %>

<%
    Document movie = (Document) request.getAttribute("movie");

    String title =
        (movie != null && movie.getString("title") != null)
        ? movie.getString("title")
        : "Movie";

    String description =
        (movie != null && movie.getString("description") != null)
        ? movie.getString("description")
        : "";

    String posterUrl =
        (movie != null && movie.getString("poster_url") != null)
        ? movie.getString("poster_url")
        : "";
    
    String bannerUrl =
    	    (movie != null && movie.getString("banner_url") != null)
    	    ? movie.getString("banner_url")
    	    : posterUrl;

    String genre =
        (movie != null && movie.getString("genre") != null)
        ? movie.getString("genre")
        : "";

    String language =
        (movie != null && movie.getString("language") != null)
        ? movie.getString("language")
        : "";

    String movieId =
        (movie != null)
        ? movie.getObjectId("_id").toString()
        : "";



    /* ---------- SAFE RATING ---------- */

    Double ratingVal = 0.0;

    if (movie != null) {

        Object ratingObj = movie.get("rating");

        if (ratingObj instanceof Integer) {

            ratingVal =
                ((Integer) ratingObj).doubleValue();

        }
        else if (ratingObj instanceof Double) {

            ratingVal = (Double) ratingObj;

        }
        else if (ratingObj instanceof Long) {

            ratingVal =
                ((Long) ratingObj).doubleValue();

        }
    }



    /* ---------- SAFE DURATION ---------- */

    Integer duration = 0;

    if (movie != null) {

        Object durationObj = movie.get("duration");

        if (durationObj instanceof Integer) {

            duration = (Integer) durationObj;

        }
        else if (durationObj instanceof Double) {

            duration =
                ((Double) durationObj).intValue();

        }
        else if (durationObj instanceof Long) {

            duration =
                ((Long) durationObj).intValue();

        }
    }



    /* ---------- STAR CALCULATION ---------- */

    int filledStars =
        (int) Math.round(ratingVal / 2.0);

    if (filledStars > 5)
        filledStars = 5;

    if (filledStars < 0)
        filledStars = 0;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        BingeIt - <%= title %>
    </title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/assets/css/global.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/assets/css/movie.css">

    <!-- HERO BG IMAGE -->
	<style>
	
	    .movie-hero-bg {
	
	        background-image:
	            url('<%= request.getContextPath() %>/<%= bannerUrl %>');
	
	    }
	
	</style>

</head>

<body>

<jsp:include page="../header.jsp" />



<!-- MOVIE HERO -->

<section class="movie-hero">

    <div class="movie-hero-bg"></div>

    <div class="movie-hero-overlay"></div>

</section>



<!-- DETAILS -->
<section class="details-section">

    <div class="details-card">



        <!-- LEFT -->
        <div class="left-col">

            <img
                class="movie-poster-img"

                src="<%= request.getContextPath() %>/<%= posterUrl %>"

                alt="<%= title %>">

            <div>

                <p class="rating-label">
                    Ratings
                </p>

                <div class="stars">

                    <%
                        for (int i = 1; i <= 5; i++) {

                            if (i <= filledStars) {
                    %>

                    <span class="star-filled">
                        &#9733;
                    </span>

                    <%
                            }
                            else {
                    %>

                    <span class="star-empty">
                        &#9733;
                    </span>

                    <%
                            }
                        }
                    %>

                </div>

            </div>

        </div>



        <!-- RIGHT -->
        <div class="right-col">

            <div class="description-box">

                <h3 class="desc-heading">
                    Description
                </h3>

                <p class="desc-text">
                    <%= description %>
                </p>

            </div>



            <% if (!genre.isEmpty()
                   || duration > 0
                   || !language.isEmpty()) { %>

            <div class="meta-row">

                <% if (!genre.isEmpty()) { %>

                    <span class="meta-tag">
                        <%= genre %>
                    </span>

                <% } %>



                <% if (duration > 0) { %>

                    <span class="meta-tag">
                        <%= duration %> min
                    </span>

                <% } %>



                <% if (!language.isEmpty()) { %>

                    <span class="meta-tag">
                        <%= language %>
                    </span>

                <% } %>

            </div>

            <% } %>

        </div>

    </div>

</section>



<!-- BOOK NOW -->
<section class="book-section">

    <a
       href="<%= request.getContextPath() %>/bookings?movieId=<%= movieId %>"

       class="book-btn">

        Book Now

    </a>

</section>



<jsp:include page="../footer.jsp" />

</body>
</html>