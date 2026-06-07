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
import static com.mongodb.client.model.Updates.set;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		request.setAttribute("currentPage", "profile");
		request.getRequestDispatcher("/profile/change-password.jsp")
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

		String userId      = (String) session.getAttribute("userId");
		String currentPass = request.getParameter("currentPassword");
		String newPass     = request.getParameter("newPassword");
		String confirmPass = request.getParameter("confirmPassword");

		// Check new passwords match
		if (!newPass.equals(confirmPass)) {
			request.setAttribute("error", "New passwords do not match.");
			request.setAttribute("currentPage", "profile");
			request.getRequestDispatcher("/profile/change-password.jsp")
					.forward(request, response);
			return;
		}

		try {
			MongoDatabase db = DBConnection.getDatabase();
			if (db != null) {
				MongoCollection<Document> users = db.getCollection("users");
				Document user = users.find(eq("_id", new ObjectId(userId))).first();

				if (user != null) {
					String storedHash = user.getString("password_hash");

					// Use BCrypt to verify current password
					boolean match = org.mindrot.jbcrypt.BCrypt.checkpw(currentPass, storedHash);

					if (!match) {
						request.setAttribute("error", "Current password is incorrect.");
						request.setAttribute("currentPage", "profile");
						request.getRequestDispatcher("/profile/change-password.jsp")
								.forward(request, response);
						return;
					}

					// Hash new password and update
					String newHash = org.mindrot.jbcrypt.BCrypt.hashpw(newPass, org.mindrot.jbcrypt.BCrypt.gensalt());
					users.updateOne(
							eq("_id", new ObjectId(userId)),
							set("password_hash", newHash)
					);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		response.sendRedirect(request.getContextPath() + "/profile");
	}
}