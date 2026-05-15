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

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("auth/reset-password.jsp").forward(req, res);
            return;
        }

        MongoCollection<Document> col =
                DBConnection.getDatabase().getCollection("users");

        if (col.find(eq("username", username)).first() == null) {
            req.setAttribute("error", "User not found");
            req.getRequestDispatcher("auth/reset-password.jsp").forward(req, res);
            return;
        }

        String hashed = PasswordUtil.hash(password);

        col.updateOne(eq("username", username),
                new Document("$set", new Document("password", hashed)));

        res.sendRedirect("auth/login.jsp");
    }
}