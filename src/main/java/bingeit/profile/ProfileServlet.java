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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String userId = (String) session.getAttribute("userId");
		System.out.println("=== ProfileServlet HIT. userId=" + userId);

		// Safe defaults
		request.setAttribute("userName",     "N/A");
		request.setAttribute("userEmail",    "N/A");
		request.setAttribute("userMobile",   "N/A");
		request.setAttribute("userUsername", "N/A");

		try {
			MongoDatabase db = DBConnection.getDatabase();
			System.out.println("=== DB: " + db);

			if (db != null) {
				MongoCollection<Document> users = db.getCollection("users");
				Document user = users.find(eq("_id", new ObjectId(userId))).first();
				System.out.println("=== User doc: " + user);

				if (user != null) {
					String name     = user.getString("name");
					String email    = user.getString("email");
					String mobile   = user.getString("mobile");
					String username = user.getString("username");

					request.setAttribute("userName",     name     != null ? name     : "N/A");
					request.setAttribute("userEmail",    email    != null ? email    : "N/A");
					request.setAttribute("userMobile",   mobile   != null ? mobile   : "N/A");
					request.setAttribute("userUsername", username != null ? username : "N/A");

					// Fix "Hi, null!" in header
					session.setAttribute("userName", name != null ? name : userId);
				}
			}

		} catch (Exception e) {
			System.out.println("=== DB ERROR: " + e.getMessage());
			e.printStackTrace();
		}

		request.setAttribute("currentPage", "profile");
		System.out.println("=== Forwarding to profile.jsp");
		request.getRequestDispatcher("/profile/profile.jsp")
				.forward(request, response);
	}
}