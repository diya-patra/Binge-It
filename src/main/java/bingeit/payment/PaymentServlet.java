package bingeit.payment;

import bingeit.config.DBConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingRef = request.getParameter("bookingRef");
        if (bookingRef == null || bookingRef.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-bookings");
            return;
        }

        MongoDatabase db = DBConnection.getDatabase();
        Document booking = null;

        try {
            MongoCollection<Document> bookingsCol = db.getCollection("bookings");
            booking = bookingsCol.find(eq("booking_reference", bookingRef)).first();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/my-bookings");
            return;
        }

        request.setAttribute("booking",     booking);
        request.setAttribute("currentPage", "bookings");
        request.getRequestDispatcher("/payment/payment.jsp").forward(request, response);
    }
}