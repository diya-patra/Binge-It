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

    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession();

        String username =
                (String) session.getAttribute("user");

        String oldPassword =
                req.getParameter("oldPassword");

        String newPassword =
                req.getParameter("newPassword");

        String confirmPassword =
                req.getParameter("confirmPassword");

        if(!newPassword.equals(confirmPassword)) {

            req.setAttribute("error",
                    "Passwords do not match");

            req.getRequestDispatcher("auth/reset-password.jsp")
                    .forward(req, res);

            return;
        }

        MongoCollection<Document> col =
                DBConnection.getDatabase()
                        .getCollection("users");

        Document user =
                col.find(eq("username", username))
                        .first();

        if(user == null ||
                !PasswordUtil.verify(
                        oldPassword,
                        user.getString("password"))) {

            req.setAttribute("error",
                    "Old password incorrect");

            req.getRequestDispatcher("auth/reset-password.jsp")
                    .forward(req, res);

            return;
        }

        String hashed =
                PasswordUtil.hash(newPassword);

        col.updateOne(
                eq("username", username),

                new Document("$set",
                        new Document("password", hashed))
        );

        res.sendRedirect("profile/profile.jsp");
    }
}