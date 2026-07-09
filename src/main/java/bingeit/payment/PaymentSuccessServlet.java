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

import java.util.Date;
import java.io.IOException;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.combine;
import static com.mongodb.client.model.Updates.set;

@WebServlet("/payment-success")
public class PaymentSuccessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingRef     = request.getParameter("bookingRef");
        String paymentMethod  = request.getParameter("paymentMethod") != null
                                ? request.getParameter("paymentMethod") : "Card";

        if (bookingRef == null || bookingRef.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-bookings");
            return;
        }

        MongoDatabase db = DBConnection.getDatabase();
        Document booking = null;

        try {
            MongoCollection<Document> bookingsCol = db.getCollection("bookings");

            // Build payment sub-document
            Document payment = new Document()
                    .append("payment_method",  paymentMethod)
                    .append("amount",          0.0) // will be updated below
                    .append("payment_status",  "Success")
                    .append("transaction_id",  "TXN" + System.currentTimeMillis())
                    .append("payment_time",    new Date());

            // Update booking status and embed payment
            bookingsCol.updateOne(
                    eq("booking_reference", bookingRef),
                    combine(
                            set("status",  "Confirmed"),
                            set("payment", payment)
                    )
            );

            booking = bookingsCol.find(eq("booking_reference", bookingRef)).first();

            // Update payment amount from booking total
            if (booking != null) {
                Double total = booking.getDouble("total_amount");
                if (total != null) {
                    payment.put("amount", total);
                    bookingsCol.updateOne(
                            eq("booking_reference", bookingRef),
                            set("payment", payment)
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/my-bookings");
            return;
        }

        request.setAttribute("booking",     booking);
        request.setAttribute("currentPage", "bookings");
        request.getRequestDispatcher("/payment/payment-success.jsp").forward(request, response);
    }
}