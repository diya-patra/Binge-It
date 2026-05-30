<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
    String userName = (String) session.getAttribute("userName");
    String userId   = (String) session.getAttribute("userId");
%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Judson:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
<!--  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">  -->

<header class="bi-header">
    <div class="bi-header__inner">

        <a href="${pageContext.request.contextPath}/home" class="bi-logo">
            <span class="bi-logo__icon">&#9654;</span>
            <span class="bi-logo__text">Binge It!!!</span>
        </a>

        <nav class="bi-nav">
            <a href="${pageContext.request.contextPath}/home"
               class="bi-nav__link <%= "home".equals(currentPage) ? "bi-nav__link--active" : "" %>">
                Home
            </a>
            <a href="${pageContext.request.contextPath}/movies"
               class="bi-nav__link <%= "movies".equals(currentPage) ? "bi-nav__link--active" : "" %>">
                Movies
            </a>
            <a href="${pageContext.request.contextPath}/bookings"
               class="bi-nav__link <%= "bookings".equals(currentPage) ? "bi-nav__link--active" : "" %>">
                Bookings
            </a>
            <a href="${pageContext.request.contextPath}/profile"
               class="bi-nav__link <%= "profile".equals(currentPage) ? "bi-nav__link--active" : "" %>">
                Profile
            </a>
            <a href="${pageContext.request.contextPath}/support"
               class="bi-nav__link <%= "support".equals(currentPage) ? "bi-nav__link--active" : "" %>">
                Support
            </a>
        </nav>

        <div class="bi-header__actions">
            <% if (userId != null) { %>
                <span class="bi-header__username">Hi, <%= userName %>!</span>
                <a href="${pageContext.request.contextPath}/logout" class="bi-btn bi-btn--outline">Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login"  class="bi-btn bi-btn--outline">Login</a>
                <a href="${pageContext.request.contextPath}/signup" class="bi-btn bi-btn--filled">Sign Up</a>
            <% } %>
        </div>

        <button class="bi-hamburger" id="biHamburger" aria-label="Toggle menu">
            <span></span><span></span><span></span>
        </button>
    </div>

    <div class="bi-mobile-nav" id="biMobileNav">
        <a href="${pageContext.request.contextPath}/home"     class="bi-mobile-nav__link">Home</a>
        <a href="${pageContext.request.contextPath}/movies"   class="bi-mobile-nav__link">Movies</a>
        <a href="${pageContext.request.contextPath}/bookings" class="bi-mobile-nav__link">Bookings</a>
        <a href="${pageContext.request.contextPath}/profile"  class="bi-mobile-nav__link">Profile</a>
        <a href="${pageContext.request.contextPath}/support"  class="bi-mobile-nav__link">Support</a>
        <% if (userId != null) { %>
            <a href="${pageContext.request.contextPath}/logout" class="bi-mobile-nav__link">Logout</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/login"  class="bi-mobile-nav__link">Login</a>
            <a href="${pageContext.request.contextPath}/signup" class="bi-mobile-nav__link">Sign Up</a>
        <% } %>
    </div>
</header>

<script>
    (function () {
        var btn = document.getElementById('biHamburger');
        var nav = document.getElementById('biMobileNav');
        if (btn && nav) {
            btn.addEventListener('click', function () {
                nav.classList.toggle('bi-mobile-nav--open');
                btn.classList.toggle('bi-hamburger--open');
            });
        }
    })();
</script>
