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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.and;

@WebServlet("/seat-selection")
public class SeatSelectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String showId = request.getParameter("showId");
        if (showId == null || showId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/bookings");
            return;
        }

        MongoDatabase db = DBConnection.getDatabase();

        Document show     = null;
        Document theatre  = null;
        Document movie    = null;
        List<Document> allSeats    = new ArrayList<>();
        Set<String> bookedSeatIds  = new HashSet<>();

        try {
            MongoCollection<Document> showsCol    = db.getCollection("shows");
            MongoCollection<Document> theatresCol = db.getCollection("theatres");
            MongoCollection<Document> moviesCol   = db.getCollection("movies");
            MongoCollection<Document> seatsCol    = db.getCollection("seats");
            MongoCollection<Document> bookingsCol = db.getCollection("bookings");

            ObjectId showOid = new ObjectId(showId);
            show = showsCol.find(eq("_id", showOid)).first();

            if (show == null) {
                response.sendRedirect(request.getContextPath() + "/bookings");
                return;
            }

            // Get theatre
            ObjectId theatreOid = show.getObjectId("theatre_id");
            theatre = theatresCol.find(eq("_id", theatreOid)).first();

            // Get movie
            ObjectId movieOid = show.getObjectId("movie_id");
            movie = moviesCol.find(eq("_id", movieOid)).first();

            // Get all seats for this theatre + screen
            String screenName = show.getString("screen_name");
            allSeats = seatsCol.find(
                    and(eq("theatre_id", theatreOid),
                        eq("screen_name", screenName))
            ).into(new ArrayList<>());

            // Get already booked seat IDs for this show
            List<Document> existingBookings = bookingsCol
                    .find(eq("show_id", showOid))
                    .into(new ArrayList<>());

            for (Document booking : existingBookings) {
                List<Document> bookedSeats = booking.getList("booked_seats", Document.class);
                if (bookedSeats != null) {
                    for (Document seat : bookedSeats) {
                        bookedSeatIds.add(seat.getObjectId("seat_id").toString());
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("show",         show);
        request.setAttribute("theatre",      theatre);
        request.setAttribute("movie",        movie);
        request.setAttribute("allSeats",     allSeats);
        request.setAttribute("bookedSeatIds", bookedSeatIds);
        request.setAttribute("showId",       showId);
        request.setAttribute("currentPage",  "bookings");

        request.getRequestDispatcher("/booking/seat-selection.jsp")
                .forward(request, response);
    }
}