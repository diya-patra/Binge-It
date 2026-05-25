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

        System.out.println("MOVIE DETAILS SERVLET RUNNING");

        // GET MOVIE ID
        String movieId = request.getParameter("id");

        // CHECK MOVIE ID
        if (movieId == null || movieId.trim().isEmpty()) {

            System.out.println("MOVIE ID MISSING");

            response.sendRedirect(request.getContextPath() + "/movies");

            return;
        }

        // DATABASE CONNECTION
        MongoDatabase db = DBConnection.getDatabase();

        // CHECK DATABASE
        if (db == null) {

            System.out.println("DATABASE CONNECTION FAILED");

            response.setContentType("text/html");

            response.getWriter().println("<h1>Database connection failed</h1>");

            return;
        }

        System.out.println("DATABASE CONNECTED");

        // MOVIES COLLECTION
        MongoCollection<Document> moviesCollection = db.getCollection("movies");

        Document movie = null;

        try {

            // CONVERT STRING TO OBJECT ID
            ObjectId oid = new ObjectId(movieId.trim());

            // FIND MOVIE
            movie = moviesCollection.find(eq("_id", oid)).first();

        } catch (IllegalArgumentException e) {

            System.out.println("INVALID OBJECT ID");

            response.sendRedirect(request.getContextPath() + "/movies");

            return;
        }

        // MOVIE NOT FOUND
        if (movie == null) {

            System.out.println("MOVIE NOT FOUND");

            response.sendRedirect(request.getContextPath() + "/movies");

            return;
        }

        System.out.println("MOVIE FOUND: " + movie.getString("title"));

        // SEND DATA TO JSP
        request.setAttribute("movie", movie);

        // FORWARD TO JSP
        request.getRequestDispatcher("/movie/movie-details.jsp")
                .forward(request, response);
    }
}