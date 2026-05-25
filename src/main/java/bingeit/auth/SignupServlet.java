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

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String name = req.getParameter("name");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String mobile = req.getParameter("mobile");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("auth/signup.jsp").forward(req, res);
            return;
        }

        MongoCollection<Document> col =
                DBConnection.getDatabase().getCollection("users");

        if (col.find(eq("username", username)).first() != null) {
            req.setAttribute("error", "Username already exists");
            req.getRequestDispatcher("auth/signup.jsp").forward(req, res);
            return;
        }

        String hashedPassword = PasswordUtil.hash(password);

        Document user = new Document("name", name)
                .append("username", username)
                .append("email", email)
                .append("mobile", mobile)
                .append("password", hashedPassword);

        col.insertOne(user);

        res.sendRedirect("auth/login.jsp");
    }
}