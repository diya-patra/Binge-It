package bingeit.profile;

import bingeit.config.DBConnection;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.combine;
import static com.mongodb.client.model.Updates.set;

@WebServlet("/edit-profile")
public class EditProfileServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String userId = (String) session.getAttribute("userId");

		// Safe defaults
		request.setAttribute("userName",     "N/A");
		request.setAttribute("userEmail",    "N/A");
		request.setAttribute("userMobile",   "N/A");
		request.setAttribute("userUsername", "N/A");

		try {
			MongoDatabase db = DBConnection.getDatabase();
			if (db != null) {
				MongoCollection<Document> users = db.getCollection("users");
				Document user = users.find(eq("_id", new ObjectId(userId))).first();
				if (user != null) {
					request.setAttribute("userName",     user.getString("name")     != null ? user.getString("name")     : "N/A");
					request.setAttribute("userEmail",    user.getString("email")    != null ? user.getString("email")    : "N/A");
					request.setAttribute("userMobile",   user.getString("mobile")   != null ? user.getString("mobile")   : "N/A");
					request.setAttribute("userUsername", user.getString("username") != null ? user.getString("username") : "N/A");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		request.setAttribute("currentPage", "profile");
		request.getRequestDispatcher("/profile/edit-profile.jsp")
				.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String userId  = (String) session.getAttribute("userId");
		String name    = request.getParameter("name");
		String mobile  = request.getParameter("mobile");
		String username = request.getParameter("username");

		try {
			MongoDatabase db = DBConnection.getDatabase();
			if (db != null) {
				MongoCollection<Document> users = db.getCollection("users");
				users.updateOne(
						eq("_id", new ObjectId(userId)),
						combine(
								set("name",     name),
								set("mobile",   mobile),
								set("username", username)
						)
				);
				// Update session
				session.setAttribute("userName", name);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		response.sendRedirect(request.getContextPath() + "/profile");
	}
}