package bingeit.profile;

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
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/my-bookings")
public class MyBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        List<Document> bookings = new ArrayList<>();

        try {
            MongoDatabase db = DBConnection.getDatabase();
            if (db != null) {
                MongoCollection<Document> bookingsCol = db.getCollection("bookings");
                bookings = bookingsCol
                        .find(eq("user_id", new ObjectId(userId)))
                        .sort(new Document("booking_date", -1))
                        .into(new ArrayList<>());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", "profile");
        request.getRequestDispatcher("/profile/my-bookings.jsp")
                .forward(request, response);
    }
}