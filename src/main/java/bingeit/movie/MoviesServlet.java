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

        MongoDatabase db = DBConnection.getDatabase();
        MongoCollection<Document> moviesCollection = db.getCollection("movies");

        String searchQuery = request.getParameter("search");
        String genreFilter = request.getParameter("genre");

        List<Document> movieList;

        // Build filter based on search and genre
        if (searchQuery != null && !searchQuery.trim().isEmpty()
                && genreFilter != null && !genreFilter.trim().isEmpty() && !genreFilter.equals("All")) {

            // Both search and genre filter
            movieList = moviesCollection.find(
                and(
                    regex("title", searchQuery.trim(), "i"),
                    eq("genre", genreFilter)
                )
            ).into(new ArrayList<>());

        } else if (searchQuery != null && !searchQuery.trim().isEmpty()) {

            // Search only
            movieList = moviesCollection.find(
                regex("title", searchQuery.trim(), "i")
            ).into(new ArrayList<>());

        } else if (genreFilter != null && !genreFilter.trim().isEmpty() && !genreFilter.equals("All")) {

            // Genre filter only
            movieList = moviesCollection.find(eq("genre", genreFilter))
                    .into(new ArrayList<>());

        } else {

            // No filter — return all movies
            movieList = moviesCollection.find().into(new ArrayList<>());
        }

        // Fetch distinct genres for the filter dropdown
        List<String> genres = Arrays.asList(
                "All", "Action", "Romance", "Horror", "Sci-Fi",
                "Comedy", "Drama", "Thriller", "Adventure"
        );

        request.setAttribute("movieList", movieList);
        request.setAttribute("genres", genres);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("selectedGenre", genreFilter);

        request.getRequestDispatcher("/WEB-INF/movie/movies.jsp")
                .forward(request, response);
    }
}
