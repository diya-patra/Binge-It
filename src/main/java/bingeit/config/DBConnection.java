package bingeit.config;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

public class DBConnection {

 private static MongoClient mongoClient = null;

 public static MongoDatabase getDatabase() {
 try {
 if (mongoClient == null) {
 String uri = AppConfig.get("db.uri");
 mongoClient = MongoClients.create(uri);
}
 String dbName = AppConfig.get("db.name");
 return mongoClient.getDatabase(dbName);
 } catch (Exception e) {
 e.printStackTrace();
 return null;
}
}
}