package bingeit.movie;

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

import java.io.IOException;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/movie-details")
public class MovieDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieId = request.getParameter("id");

        // If no ID provided, redirect back to movies list
        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        MongoDatabase db = DBConnection.getDatabase();
        MongoCollection<Document> moviesCollection = db.getCollection("movies");

        Document movie = null;

        try {
            ObjectId oid = new ObjectId(movieId.trim());
            movie = moviesCollection.find(eq("_id", oid)).first();
        } catch (IllegalArgumentException e) {
            // Invalid ObjectId format
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        // If movie not found, redirect to movies list
        if (movie == null) {
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        request.setAttribute("movie", movie);

        request.getRequestDispatcher("/WEB-INF/movie/movie-details.jsp")
                .forward(request, response);
    }
}
