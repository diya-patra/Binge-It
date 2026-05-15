package bingeit.auth;

import bingeit.config.DBConnection;
import bingeit.util.EmailUtil;

import com.mongodb.client.MongoCollection;
import org.bson.Document;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String email = req.getParameter("email");

        MongoCollection<Document> col =
                DBConnection.getDatabase().getCollection("users");

        Document user = col.find(eq("email", email)).first();

        if (user == null) {
            req.setAttribute("error", "Email not found");
            req.getRequestDispatcher("auth/forgot-password.jsp").forward(req, res);
            return;
        }

        String username = user.getString("username");

        // simple reset link (no token for now)
        String resetLink = "http://localhost:8080/yourProjectName/auth/reset-password.jsp?user=" + username;

        EmailUtil.sendResetEmail(email, resetLink);

        req.setAttribute("msg", "Reset link sent to your email");
        req.getRequestDispatcher("auth/forgot-password.jsp").forward(req, res);
    }
}