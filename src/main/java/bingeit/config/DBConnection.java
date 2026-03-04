package bingeit.config; 
 
import java.sql.Connection; 
import java.sql.DriverManager; 
 
public class DBConnection { 
 
    public static Connection getConnection() { 
        try { 
 
            String url = AppConfig.get("db.url"); 
            String user = AppConfig.get("db.username"); 
            String pass = AppConfig.get("db.password"); 
 
            return DriverManager.getConnection(url, user, pass); 
 
        } catch (Exception e) { 
            e.printStackTrace(); 
            return null; 
        } 
    } 
}