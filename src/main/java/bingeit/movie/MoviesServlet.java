package bingeit.movie;

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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import static com.mongodb.client.model.Filters.*;

@WebServlet("/movies")
public class MoviesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION CHECK
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("MOVIES SERVLET RUNNING");

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

        System.out.println("TOTAL MOVIES IN COLLECTION: "
                + moviesCollection.countDocuments());

        // PARAMETERS
        String searchQuery = request.getParameter("search");
        String genreFilter = request.getParameter("genre");

        List<Document> movieList;

        // BOTH SEARCH + GENRE
        if (searchQuery != null
                && !searchQuery.trim().isEmpty()
                && genreFilter != null
                && !genreFilter.trim().isEmpty()
                && !genreFilter.equals("All")) {

            movieList = moviesCollection.find(
                    and(
                        regex("title", searchQuery.trim(), "i"),
                        eq("genre", genreFilter)
                    )
            ).into(new ArrayList<>());

        }
        // ONLY SEARCH
        else if (searchQuery != null && !searchQuery.trim().isEmpty()) {

            movieList = moviesCollection.find(
                    regex("title", searchQuery.trim(), "i")
            ).into(new ArrayList<>());

        }
        // ONLY GENRE
        else if (genreFilter != null
                && !genreFilter.trim().isEmpty()
                && !genreFilter.equals("All")) {

            movieList = moviesCollection.find(
                    eq("genre", genreFilter)
            ).into(new ArrayList<>());

        }
        // ALL MOVIES
        else {
            movieList = moviesCollection.find().into(new ArrayList<>());
            System.out.println("MOVIE LIST SIZE: " + movieList.size());
        }

        System.out.println("Movies Found: " + movieList.size());

        // GENRES
        List<String> genres = Arrays.asList(
                "All", "Action", "Romance", "Horror",
                "Sci-Fi", "Comedy", "Drama", "Thriller", "Adventure"
        );

        // SEND DATA TO JSP
        request.setAttribute("movieList",     movieList);
        request.setAttribute("genres",        genres);
        request.setAttribute("searchQuery",   searchQuery);
        request.setAttribute("selectedGenre", genreFilter);
        request.setAttribute("currentPage",   "movies");

        request.getRequestDispatcher("/movie/movies.jsp").forward(request, response);
    }
}