package bingeit.auth;

import bingeit.config.DBConnection;
import bingeit.util.EmailUtil;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.Date;
import java.util.UUID;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        String email = req.getParameter("email");

        MongoCollection<Document> col =
                DBConnection.getDatabase().getCollection("users");

        Document user = col.find(eq("email", email)).first();

        if (user == null) {
            // Don't reveal whether email exists — show same success message
            req.setAttribute("success",
                "If that email is registered, a reset link has been sent.");
            req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, res);
            return;
        }

        // Generate token
        String token = UUID.randomUUID().toString();
        Date expiry = new Date(System.currentTimeMillis() + 30 * 60 * 1000); // 30 min

        col.updateOne(eq("email", email),
                new Document("$set", new Document()
                        .append("reset_token", token)
                        .append("reset_token_expiry", expiry)));

        String resetLink = req.getScheme() + "://"
                + req.getServerName() + ":" + req.getServerPort()
                + req.getContextPath()
                + "/reset-password?token=" + token;

        EmailUtil.sendResetEmail(email, resetLink);

        req.setAttribute("success",
                "If that email is registered, a reset link has been sent.");
        req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, res);
    }
}