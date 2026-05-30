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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        MongoCollection<Document> col =
                DBConnection.getDatabase().getCollection("users");

        Document user = col.find(eq("email", email)).first();

        if (user != null &&
                PasswordUtil.verify(password, user.getString("password_hash"))) {

            HttpSession session = req.getSession();
            session.setAttribute("userId",   user.getObjectId("_id").toString());
            session.setAttribute("userName", user.getString("name"));
            session.setAttribute("userRole", user.getString("role"));

            res.sendRedirect(req.getContextPath() + "/home");

        } else {
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
        }
    }
}