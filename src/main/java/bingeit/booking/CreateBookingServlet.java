package bingeit.booking;

import bingeit.config.DBConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/create-booking")
public class CreateBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId  = (String) session.getAttribute("userId");
        String showId  = request.getParameter("showId");
        String[] seatIds = request.getParameterValues("seatIds");

        if (showId == null || seatIds == null || seatIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/bookings");
            return;
        }

        MongoDatabase db = DBConnection.getDatabase();
        Document savedBooking = null;

        try {
            MongoCollection<Document> showsCol    = db.getCollection("shows");
            MongoCollection<Document> seatsCol    = db.getCollection("seats");
            MongoCollection<Document> bookingsCol = db.getCollection("bookings");

            ObjectId showOid = new ObjectId(showId);
            Document show = showsCol.find(eq("_id", showOid)).first();

            if (show == null) {
                response.sendRedirect(request.getContextPath() + "/bookings");
                return;
            }

            List<Document> bookedSeats = new ArrayList<>();
            double totalAmount = 0;

            for (String seatId : seatIds) {
                ObjectId seatOid = new ObjectId(seatId.trim());
                Document seat = seatsCol.find(eq("_id", seatOid)).first();
                if (seat != null) {
                    String seatType = seat.getString("seat_type");
                    double price    = getPrice(seatType, show);
                    totalAmount    += price;
                    bookedSeats.add(new Document()
                            .append("seat_id",     seatOid)
                            .append("seat_number", seat.getString("seat_number"))
                            .append("seat_type",   seatType)
                            .append("price",       price));
                }
            }

            long count = bookingsCol.countDocuments() + 1;
            String bookingRef = String.format("BKG%d%03d",
                    java.time.LocalDate.now().getYear(), count);

            Document booking = new Document()
                    .append("booking_reference", bookingRef)
                    .append("user_id",           new ObjectId(userId))
                    .append("show_id",           showOid)
                    .append("booked_seats",      bookedSeats)
                    .append("booking_date",      new Date())
                    .append("total_amount",      totalAmount)
                    .append("status",            "Pending");

            bookingsCol.insertOne(booking);
            savedBooking = booking;

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("booking",     savedBooking);
        request.setAttribute("currentPage", "bookings");
        request.getRequestDispatcher("/booking/booking-summary.jsp")
                .forward(request, response);
    }

    private double getPrice(String seatType, Document show) {
        if (seatType == null) return 0;
        switch (seatType) {
            case "Silver":   return show.get("price_silver")   instanceof Number
                             ? ((Number) show.get("price_silver")).doubleValue()   : 150.0;
            case "Gold":     return show.get("price_gold")     instanceof Number
                             ? ((Number) show.get("price_gold")).doubleValue()     : 250.0;
            case "Platinum": return show.get("price_platinum") instanceof Number
                             ? ((Number) show.get("price_platinum")).doubleValue() : 400.0;
            default:         return 0;
        }
    }
}