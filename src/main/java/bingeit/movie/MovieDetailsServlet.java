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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/movie-details")
public class MovieDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("MOVIE DETAILS SERVLET RUNNING");

        // GET MOVIE ID
        String movieId = request.getParameter("id");

        if (movieId == null || movieId.trim().isEmpty()) {
            System.out.println("MOVIE ID MISSING");
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        // DATABASE CONNECTION
        MongoDatabase db = DBConnection.getDatabase();

        if (db == null) {
            System.out.println("DATABASE CONNECTION FAILED");
            response.setContentType("text/html");
            response.getWriter().println("<h1>Database connection failed</h1>");
            return;
        }

        System.out.println("DATABASE CONNECTED");

        MongoCollection<Document> moviesCollection = db.getCollection("movies");
        Document movie = null;

        try {
            ObjectId oid = new ObjectId(movieId.trim());
            movie = moviesCollection.find(eq("_id", oid)).first();
        } catch (IllegalArgumentException e) {
            System.out.println("INVALID OBJECT ID");
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        if (movie == null) {
            System.out.println("MOVIE NOT FOUND");
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        System.out.println("MOVIE FOUND: " + movie.getString("title"));

        request.setAttribute("movie", movie);

        request.getRequestDispatcher("/movie/movie-details.jsp").forward(request, response);
    }
}