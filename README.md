# 🎬 BingeIt

BingeIt is a Java-based web application for movie ticket booking developed using JSP, Jakarta Servlets, MongoDB, and Apache Tomcat. The application allows users to register, log in securely, browse movies, and manage bookings through a responsive web interface.

---

# Features

- User Registration
- User Login & Logout
- Secure Password Hashing using BCrypt
- Session-based Authentication
- Browse Movies
- Movie Categories
- MongoDB Database Integration
- Responsive User Interface
- Custom Error Pages
- Docker Deployment
- Cloud Deployment on Render

---

# Tech Stack

## Frontend

- HTML5
- CSS3
- JavaScript
- JSP

## Backend

- Java 25
- Jakarta Servlets
- Apache Tomcat 11

## Database

- MongoDB Atlas

## Libraries

- MongoDB Java Driver
- BCrypt
- Jakarta Mail
- Jakarta Activation
- iText PDF

---

# Project Structure

```
BingeIt
│
├── src
│   └── main
│       ├── java
│       │
│       │   ├── bingeit.auth
│       │   ├── bingeit.home
│       │   ├── bingeit.config
│       │   ├── bingeit.util
│       │   └── ...
│       │
│       ├── resources
│       │   └── app.properties
│       │
│       └── webapp
│           ├── assets
│           ├── auth
│           ├── home
│           ├── WEB-INF
│           ├── header.jsp
│           ├── footer.jsp
│           ├── error.jsp
│           └── index.jsp
│
├── Dockerfile
├── BingeIt.war
└── README.md
```

---

# Application Flow

```
Browser

      │

      ▼

JSP Pages

      │

      ▼

Servlets

      │

      ▼

MongoDB Atlas
```

The application uses Servlets to process requests, communicate directly with MongoDB, and forward data to JSP pages for rendering.

---

# Requirements

- Java JDK 25
- Apache Tomcat 11
- MongoDB Atlas
- Eclipse IDE (Dynamic Web Project)

---

# Running the Project Locally

## 1. Clone the Repository

```bash
git clone https://github.com/yourusername/BingeIt.git
```

---

## 2. Configure Database

Create:

```
src/main/resources/app.properties
```

Example:

```properties
db.uri=YOUR_MONGODB_CONNECTION_STRING
db.name=BingeIt

mail.email=YOUR_EMAIL
mail.password=YOUR_PASSWORD
```

The application can also read these values from environment variables.

---

## 3. Import into Eclipse

Import the project as a Dynamic Web Project.

Configure:

- JDK 25
- Apache Tomcat 11 Runtime

---

## 4. Build WAR

Export:

```
BingeIt.war
```

---

## 5. Run

Deploy the WAR to Tomcat.

Open

```
http://localhost:8080/BingeIt
```

---

# Docker Deployment

```dockerfile
FROM tomcat:11.0-jdk25

RUN rm -rf /usr/local/tomcat/webapps/*

COPY BingeIt.war /usr/local/tomcat/webapps/ROOT.war

RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

---

# Environment Variables

For production deployment, configure:

```
DB_URI
DB_NAME
MAIL_EMAIL
MAIL_PASSWORD
```

These override values in `app.properties`.

---

# Security

- BCrypt password hashing
- Session-based authentication
- Externalized configuration
- MongoDB Atlas connection
- Custom error pages

---

# Deployment

The application is containerized using Docker and deployed on Render with Apache Tomcat 11.

---

# Deployment Issue & Resolution

During deployment, the application successfully built and deployed but returned HTTP 404 and 500 errors.

### Cause

The project was compiled using **JDK 25**, while the Docker container was using **Tomcat with JDK 17**. This Java version mismatch prevented the application from functioning correctly after deployment.

### Solution

The Docker image was updated to:

```dockerfile
FROM tomcat:11.0-jdk25
```

After rebuilding the WAR and redeploying, the application worked as expected.

---

# Future Improvements

- Seat Selection
- Online Payments
- Booking History
- Movie Reviews
- Search & Filters
- Admin Dashboard
- QR Code Tickets
- Email Notifications
- Recommendation System

---

# Author

**Diya Patra**

Bachelor of Computer Applications (BCA)

NSHM College of Management & Technology

---

# License

This project is intended for educational and learning purposes.