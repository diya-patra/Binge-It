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

                System.out.println("URI = " + uri);

                mongoClient = MongoClients.create(uri);

                System.out.println("Mongo Client Created");
            }

            String dbName = AppConfig.get("db.name");

            System.out.println("DB NAME = " + dbName);

            MongoDatabase db = mongoClient.getDatabase(dbName);

            System.out.println("DATABASE OBJECT = " + db);

            return db;

        } catch (Exception e) {

            e.printStackTrace();

            return null;
        }
    }
}