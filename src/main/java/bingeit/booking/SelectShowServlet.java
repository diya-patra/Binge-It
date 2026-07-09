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
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/bookings")
public class SelectShowServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        MongoDatabase db = DBConnection.getDatabase();
        String movieId = request.getParameter("movieId");

        List<Document> shows    = new ArrayList<>();
        List<Document> theatres = new ArrayList<>();
        List<Document> movies   = new ArrayList<>();
        Document movie = null;

        try {
            MongoCollection<Document> moviesCol   = db.getCollection("movies");
            MongoCollection<Document> showsCol    = db.getCollection("shows");
            MongoCollection<Document> theatresCol = db.getCollection("theatres");

            theatres = theatresCol.find().into(new ArrayList<>());

            if (movieId != null && !movieId.isEmpty()) {
                // Coming from Book Now — specific movie
                ObjectId movieOid = new ObjectId(movieId);
                movie = moviesCol.find(eq("_id", movieOid)).first();
                shows = showsCol.find(eq("movie_id", movieOid)).into(new ArrayList<>());
            } else {
                // Coming from navbar — load all shows + all movies for lookup
                shows  = showsCol.find().into(new ArrayList<>());
                movies = moviesCol.find().into(new ArrayList<>());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("movie",    movie);
        request.setAttribute("shows",    shows);
        request.setAttribute("theatres", theatres);
        request.setAttribute("movies",   movies);
        request.setAttribute("movieId",  movieId);
        request.setAttribute("currentPage", "bookings");

        request.getRequestDispatcher("/booking/select-show.jsp")
                .forward(request, response);
    }
}