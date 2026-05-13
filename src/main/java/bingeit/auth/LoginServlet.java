package bingetit.auth;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

import bingetit.config.MongoUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        MongoCollection<Document> col =
                MongoUtil.getDB().getCollection("users");

        Document user = col.find(eq("username", username)).first();

        if (user != null && user.getString("password").equals(password)) {

            req.getSession().setAttribute("user", username);
            res.sendRedirect("home/home.jsp");

        } else {
            res.getWriter().println("Invalid Login");
        }
    }
}