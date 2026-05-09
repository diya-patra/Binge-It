package bingeit.util;

import bingeit.config.AppConfig;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    public static void sendResetEmail(String toEmail, String resetLink) {

        String host = AppConfig.get("mail.host");
        String port = AppConfig.get("mail.port");
        String username = AppConfig.get("mail.username");
        String password = AppConfig.get("mail.password");

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
            new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(toEmail));
            message.setSubject("BingeIt - Password Reset Request");
            message.setText(
                "Hello,\n\n" +
                "You requested a password reset for your BingeIt account.\n\n" +
                "Click the link below to reset your password:\n" +
                resetLink + "\n\n" +
                "This link expires in 30 minutes.\n\n" +
                "If you did not request this, ignore this email.\n\n" +
                "- BingeIt Team"
            );
            Transport.send(message);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}