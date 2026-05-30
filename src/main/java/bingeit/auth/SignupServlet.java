package bingeit.auth;

import bingeit.config.DBConnection;
import bingeit.util.PasswordUtil;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.Date;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        req.getRequestDispatcher("/auth/signup.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        String name     = req.getParameter("name");
        String username = req.getParameter("username");
        String email    = req.getParameter("email");
        String mobile   = req.getParameter("mobile");
        String password = req.getParameter("password");
        String confirm  = req.getParameter("confirm");

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("/auth/signup.jsp").forward(req, res);
            return;
        }

        MongoCollection<Document> col =
                DBConnection.getDatabase().getCollection("users");

        if (col.find(eq("username", username)).first() != null) {
            req.setAttribute("error", "Username already taken");
            req.getRequestDispatcher("/auth/signup.jsp").forward(req, res);
            return;
        }

        if (col.find(eq("email", email)).first() != null) {
            req.setAttribute("error", "Email already registered");
            req.getRequestDispatcher("/auth/signup.jsp").forward(req, res);
            return;
        }

        Document user = new Document()
                .append("name", name)
                .append("username", username)
                .append("email", email)
                .append("mobile", mobile)
                .append("password_hash", PasswordUtil.hash(password))
                .append("role", "customer")
                .append("created_at", new Date())
                .append("reset_token", null)
                .append("reset_token_expiry", null);

        col.insertOne(user);
        res.sendRedirect(req.getContextPath() + "/login");
    }
}