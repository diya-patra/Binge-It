package bingeit.booking;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Properties;

@WebServlet("/CreateBookingServlet")
public class CreateBookingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String MONGO_URI = "mongodb+srv://bingeitAdmin:hTS1IFg9Q9OZ9vDT@bingeitcluster.f1qwsrk.mongodb.net/?appName=bingeitCluster";
	private static final String DB_NAME = "bingeit";
	private static final String COLLECTION_NAME = "bookings";

	private static final String MAIL_HOST = "smtp.gmail.com";
	private static final String MAIL_PORT = "587";
	private static final String MAIL_USERNAME = "bingeit.noreply@gmail.com";
	private static final String MAIL_PASSWORD = "slpsiqnhqhnlkpif";

	public CreateBookingServlet() {
		super();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StringBuilder sb = new StringBuilder();
		String line;
		try (BufferedReader reader = request.getReader()) {
			while ((line = reader.readLine()) != null) {
				sb.append(line);
			}
		}

		Gson gson = new Gson();
		JsonObject jsonObject = gson.fromJson(sb.toString(), JsonObject.class);

		String movie = jsonObject.get("movie").getAsString();
		String date = jsonObject.get("date").getAsString();
		String time = jsonObject.get("time").getAsString();
		String totalAmount = jsonObject.get("totalAmount").getAsString();
		List<Object> seats = gson.fromJson(jsonObject.get("seats"), List.class);

		StringBuilder seatNames = new StringBuilder();
		for (Object seatObj : seats) {
			java.util.Map<String, Object> seatMap = (java.util.Map<String, Object>) seatObj;
			seatNames.append(seatMap.get("id")).append(" ");
		}

		HttpSession session = request.getSession(false);
		String name = (session != null && session.getAttribute("name") != null) ? (String) session.getAttribute("name") : "Guest User";
		String username = (session != null && session.getAttribute("username") != null) ? (String) session.getAttribute("username") : "Guest";
		String email = (session != null && session.getAttribute("email") != null) ? (String) session.getAttribute("email") : "Unknown";

		try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
			MongoDatabase database = mongoClient.getDatabase(DB_NAME);
			MongoCollection<Document> collection = database.getCollection(COLLECTION_NAME);

			Document bookingDocument = new Document()
					.append("username", username)
					.append("email", email)
					.append("movie_title", movie)
					.append("show_date", date)
					.append("show_time", time)
					.append("seats_booked", seats)
					.append("total_amount", Double.parseDouble(totalAmount))
					.append("booking_status", "Payment Pending")
					.append("created_at", new Date());

			collection.insertOne(bookingDocument);

			if (!email.equals("Unknown")) {
				sendConfirmationEmail(email, name, movie, date, time, seatNames.toString().trim(), totalAmount);
			}

			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write("Booking successfully saved to database! A confirmation email has been sent to " + email);

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("Error saving booking: " + e.getMessage());
		}
	}

	private void sendConfirmationEmail(String toEmail, String name, String movie, String date, String time, String seats, String totalAmount) {
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", MAIL_HOST);
		props.put("mail.smtp.port", MAIL_PORT);

		Session mailSession = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(MAIL_USERNAME, MAIL_PASSWORD);
			}
		});

		try {
			Message message = new MimeMessage(mailSession);
			message.setFrom(new InternetAddress(MAIL_USERNAME, "BingeIt Cinemas"));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
			message.setSubject("Your Movie Ticket Confirmation - " + movie);

			String emailContent = "Hello " + name + ",\n\n"
					+ "Your booking has been initiated successfully!\n\n"
					+ "--- BOOKING DETAILS ---\n"
					+ "Movie: " + movie + "\n"
					+ "Date: " + date + "\n"
					+ "Time: " + time + "\n"
					+ "Seats: " + seats + "\n"
					+ "Total Amount: ₹" + totalAmount + "\n"
					+ "Status: Payment Pending\n\n"
					+ "Thank you for choosing BingeIt!";

			message.setText(emailContent);
			Transport.send(message);

		} catch (Exception e) {
			System.err.println("Failed to send email confirmation: " + e.getMessage());
			e.printStackTrace();
		}
	}
}