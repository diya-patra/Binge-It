package bingetit.auth;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

import bingetit.config.MongoUtil;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        if (!password.equals(confirm)) {
            res.getWriter().println("Password mismatch");
            return;
        }

        MongoCollection<Document> col =
                MongoUtil.getDB().getCollection("users");

        if (col.find(eq("username", username)).first() == null) {
            res.getWriter().println("User not found");
            return;
        }

        col.updateOne(eq("username", username),
                new Document("$set", new Document("password", password)));

        res.sendRedirect("auth/login.jsp");
    }
}