<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="bi-footer">
    <div class="bi-footer__inner">

        <div class="bi-footer__brand">
            <a href="${pageContext.request.contextPath}/home" class="bi-logo bi-logo--light">
                <span class="bi-logo__icon">&#9654;</span>
                <span class="bi-logo__text">Binge It!!!</span>
            </a>
            <p class="bi-footer__tagline">Book your favourite seats now</p>
        </div>

        <div class="bi-footer__links">
            <h4 class="bi-footer__heading">Quick Links</h4>
            <a href="${pageContext.request.contextPath}/home"     class="bi-footer__link">Home</a>
            <a href="${pageContext.request.contextPath}/movies"   class="bi-footer__link">Movies</a>
            <a href="${pageContext.request.contextPath}/bookings" class="bi-footer__link">My Bookings</a>
            <a href="${pageContext.request.contextPath}/profile"  class="bi-footer__link">Profile</a>
        </div>

        <div class="bi-footer__social">
            <h4 class="bi-footer__heading">Follow Us</h4>
            <div class="bi-footer__social-links">
                <a href="#" class="bi-footer__social-link">Facebook</a>
                <a href="#" class="bi-footer__social-link">Instagram</a>
                <a href="#" class="bi-footer__social-link">Twitter</a>
            </div>
        </div>

    </div>

    <div class="bi-footer__bottom">
        <p>&copy; Bing It. All Rights Reserved.</p>
    </div>
</footer>
