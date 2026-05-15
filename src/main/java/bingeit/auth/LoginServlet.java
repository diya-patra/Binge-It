package bingeit.auth;

import bingeit.config.DBConnection;
import bingeit.util.PasswordUtil;

import com.mongodb.client.MongoCollection;
import org.bson.Document;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        MongoCollection<Document> col =
                DBConnection.getDatabase().getCollection("users");

        Document user = col.find(eq("username", username)).first();

        if (user != null &&
                PasswordUtil.verify(password, user.getString("password"))) {

            req.getSession().setAttribute("user", username);
            res.sendRedirect("home/home.jsp");

        } else {
            req.setAttribute("error", "Invalid Username or Password");
            req.getRequestDispatcher("auth/login.jsp").forward(req, res);
        }
    }
}