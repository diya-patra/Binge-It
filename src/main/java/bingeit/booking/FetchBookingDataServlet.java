package bingeit.booking;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/FetchBookingDataServlet")
public class FetchBookingDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String MONGO_URI = "mongodb+srv://bingeitAdmin:hTS1IFg9Q9OZ9vDT@bingeitcluster.f1qwsrk.mongodb.net/?appName=bingeitCluster";
    private static final String DB_NAME = "bingeit";

    public FetchBookingDataServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        JsonObject responseData = new JsonObject();
        JsonArray moviesArray = new JsonArray();
        JsonObject showtimesObj = new JsonObject();

        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);

            MongoCollection<Document> moviesCollection = database.getCollection("movies");
            for (Document doc : moviesCollection.find()) {
                JsonObject movie = new JsonObject();
                movie.addProperty("id", doc.getObjectId("_id").toHexString());
                movie.addProperty("title", doc.getString("title"));
                movie.addProperty("lang", doc.getString("language"));
                movie.addProperty("genre", doc.getString("genre"));
                Object duration = doc.get("duration");
                movie.addProperty("duration", (duration != null ? duration.toString() : "120") + " mins");
                Object rating = doc.get("rating");
                movie.addProperty("rating", (rating != null ? rating.toString() : "N/A") + "/10");
                moviesArray.add(movie);
            }

            JsonArray times1 = new JsonArray();
            times1.add("10:00 AM"); times1.add("01:15 PM"); times1.add("06:30 PM");

            JsonArray times2 = new JsonArray();
            times2.add("11:30 AM"); times2.add("04:00 PM"); times2.add("08:45 PM");

            showtimesObj.add("2026-06-05", times1);
            showtimesObj.add("2026-06-06", times2);
            showtimesObj.add("2026-06-07", times1);

            responseData.add("movies", moviesArray);
            responseData.add("showtimes", showtimesObj);

            out.write(new Gson().toJson(responseData));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Failed to load database content.\"}");
        }
    }
}