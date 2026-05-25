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

        System.out.println("HOME SERVLET RUNNING");

        // DATABASE CONNECTION
        MongoDatabase db = DBConnection.getDatabase();

        // CHECK DATABASE CONNECTION
        if (db == null) {

            System.out.println("DATABASE CONNECTION FAILED");

            response.setContentType("text/html");

            response.getWriter().println("<h1>Database connection failed</h1>");

            return;
        }

        System.out.println("DATABASE CONNECTED");

        // GET MOVIES COLLECTION
        MongoCollection<Document> movies = db.getCollection("movies");

        // RECOMMENDED MOVIES
        List<Document> recommendedMovies = movies.find()
                .sort(new Document("rating", -1))
                .limit(4)
                .into(new ArrayList<>());

        // ROMANTIC MOVIES
        List<Document> romanticMovies = movies.find(eq("genre", "Romance"))
                .limit(4)
                .into(new ArrayList<>());

        // ACTION MOVIES
        List<Document> actionMovies = movies.find(eq("genre", "Action"))
                .limit(4)
                .into(new ArrayList<>());

        // DEBUG OUTPUT
        System.out.println("Recommended Movies: " + recommendedMovies.size());
        System.out.println("Romantic Movies: " + romanticMovies.size());
        System.out.println("Action Movies: " + actionMovies.size());

        // SEND DATA TO JSP
        request.setAttribute("recommendedMovies", recommendedMovies);
        request.setAttribute("romanticMovies", romanticMovies);
        request.setAttribute("actionMovies", actionMovies);

        // FORWARD TO JSP
        request.getRequestDispatcher("/home/home.jsp")
                .forward(request, response);
    }
}