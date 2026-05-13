package bingetit.auth;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

import bingetit.config.MongoUtil;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        String name = req.getParameter("name");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String mobile = req.getParameter("mobile");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        if (!password.equals(confirm)) {
            res.getWriter().println("Password mismatch");
            return;
        }

        MongoCollection<Document> col =
                MongoUtil.getDB().getCollection("users");

        if (col.find(eq("username", username)).first() != null) {
            res.getWriter().println("Username exists");
            return;
        }

        Document user = new Document("name", name)
                .append("username", username)
                .append("email", email)
                .append("mobile", mobile)
                .append("password", password);

        col.insertOne(user);

        res.sendRedirect("auth/login.jsp");
    }
}