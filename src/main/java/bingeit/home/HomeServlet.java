package bingeit.home;

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
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        MongoDatabase db = DBConnection.getDatabase();
        MongoCollection<Document> movies = db.getCollection("movies");

        // Fetch recommended movies (first 4, or add your own logic e.g. by rating)
        List<Document> recommendedMovies = movies.find()
                .sort(new Document("rating", -1))
                .limit(4)
                .into(new ArrayList<>());

        // Fetch romantic genre movies
        List<Document> romanticMovies = movies.find(eq("genre", "Romance"))
                .limit(4)
                .into(new ArrayList<>());

        // Fetch action genre movies (for a third row if needed)
        List<Document> actionMovies = movies.find(eq("genre", "Action"))
                .limit(4)
                .into(new ArrayList<>());

        request.setAttribute("recommendedMovies", recommendedMovies);
        request.setAttribute("romanticMovies", romanticMovies);
        request.setAttribute("actionMovies", actionMovies);

        request.getRequestDispatcher("/WEB-INF/home/home.jsp")
                .forward(request, response);
    }
}
