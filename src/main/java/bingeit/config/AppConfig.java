package bingeit.config; 
 
import java.io.InputStream; 
import java.util.Properties; 
 
public class AppConfig { 
 
    private static Properties properties = new Properties(); 
 
    static { 
        try { 
            InputStream input = AppConfig.class 
                    .getClassLoader() 
                    .getResourceAsStream("app.properties"); 
 
            properties.load(input); 
 
        } catch (Exception e) { 
            e.printStackTrace(); 
        } 
    } 
 
    public static String get(String key) { 
        return properties.getProperty(key); 
    } 
}