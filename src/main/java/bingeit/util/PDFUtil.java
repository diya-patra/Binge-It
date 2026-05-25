package bingeit.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import org.bson.Document;

import java.io.FileOutputStream;
import java.util.List;

public class PDFUtil {

    public static String generateTicket(Document booking) {

        String bookingRef = booking.getString("booking_reference");
        String filePath = System.getProperty("java.io.tmpdir")
                          + "/" + bookingRef + ".pdf";

        try {
            com.itextpdf.text.Document pdf = new com.itextpdf.text.Document();
            PdfWriter.getInstance(pdf, new FileOutputStream(filePath));
            pdf.open();

            // Title
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD);
            Font headingFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);

            Paragraph title = new Paragraph("BingeIt - Movie Ticket", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            pdf.add(title);

            pdf.add(new Paragraph("Booking Reference: " + bookingRef, headingFont));
            pdf.add(new Paragraph("Status: " + booking.getString("status"), normalFont));
            pdf.add(new Paragraph("Total Amount: Rs. " + booking.getDouble("total_amount"), normalFont));
            pdf.add(new Paragraph(" "));

            // Seats
            pdf.add(new Paragraph("Seats Booked:", headingFont));
            List<Document> seats = booking.getList("booked_seats", Document.class);
            if (seats != null) {
                for (Document seat : seats) {
                    pdf.add(new Paragraph(
                        "  Seat: " + seat.getString("seat_number") +
                        " | Type: " + seat.getString("seat_type") +
                        " | Price: Rs. " + seat.getDouble("price"),
                        normalFont
                    ));
                }
            }

            pdf.add(new Paragraph(" "));

            // Payment
            Document payment = (Document) booking.get("payment");
            if (payment != null) {
                pdf.add(new Paragraph("Payment Details:", headingFont));
                pdf.add(new Paragraph("  Method: " + payment.getString("payment_method"), normalFont));
                pdf.add(new Paragraph("  Transaction ID: " + payment.getString("transaction_id"), normalFont));
                pdf.add(new Paragraph("  Status: " + payment.getString("payment_status"), normalFont));
            }

            pdf.add(new Paragraph(" "));
            pdf.add(new Paragraph("Thank you for booking with BingeIt! Enjoy your movie.", normalFont));

            pdf.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return filePath;
    }
}