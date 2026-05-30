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

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        String token = req.getParameter("token");
        if (token == null || token.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.setAttribute("token", token);
        req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        String token           = req.getParameter("token");
        String newPassword     = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, res);
            return;
        }

        MongoCollection<Document> col =
                DBConnection.getDatabase().getCollection("users");

        Document user = col.find(eq("reset_token", token)).first();

        if (user == null) {
            req.setAttribute("error", "Invalid or expired reset link");
            req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, res);
            return;
        }

        // Check expiry
        Date expiry = user.getDate("reset_token_expiry");
        if (expiry == null || expiry.before(new Date())) {
            req.setAttribute("error", "Reset link has expired. Please request a new one.");
            req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, res);
            return;
        }

        // Update password and clear token
        col.updateOne(eq("reset_token", token),
                new Document("$set", new Document()
                        .append("password_hash", PasswordUtil.hash(newPassword))
                        .append("reset_token", null)
                        .append("reset_token_expiry", null)));

        res.sendRedirect(req.getContextPath() + "/login");
    }
}