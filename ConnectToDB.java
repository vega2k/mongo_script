package mymongo;

import java.util.ArrayList;
import java.util.List;

import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;

public class ConnectToDB {

	public static void main(String args[]) {

		// Creating a Mongo client
		MongoClient mongo = new MongoClient("localhost", 27017);
		System.out.println("MongoClient " + mongo);

		// Accessing the database
		MongoDatabase database = mongo.getDatabase("myDb");
		System.out.println("Mongo DB " + database);
		System.out.println("Connected to the DB successfully");

		// Creating a collection
		//database.createCollection("sampleCollection");
		//System.out.println("Collection created successfully");

		// Retrieving a collection
		MongoCollection<Document> collection = database.getCollection("sampleCollection");
		
		Document document = new Document("title", "MongoDB")
				.append("description", "database")
				.append("likes", 100)
				.append("url", "http://www.tutorialspoint.com/mongodb/")
				.append("by", "tutorials point");
		
		//Inserting document into the collection
		//collection.insertOne(document);
		
		Document document2 = new Document("title", "RethinkDB")
				.append("description", "database")
				.append("likes", 200)
				.append("url", "http://www.tutorialspoint.com/rethinkdb/")
				.append("by", "tutorials point");
		
		List<Document> list = new ArrayList<Document>();
		list.add(document);
		list.add(document2);
		
		//collection.insertMany(list);
		
		//collection updateOne()
		collection.updateOne(Filters.eq("title", "MongoDB"),
		Updates.set("likes", 150)); 
		System.out.println("Document update successfully...");
		
		// Deleting the documents 
		 collection.deleteOne(Filters.eq("title", "MongoDB"));
		 System.out.println("Document deleted successfully..."); 
		 
		//Finding document 
		FindIterable<Document> iterDoc = collection.find();
		//Consumer의 void accept​(T t)
		iterDoc.forEach((Document doc) -> System.out.println(doc));

		//iterDoc.forEach(System.out::println);

		
		// Dropping a Collection 
		 collection.drop();
		
		mongo.close();
	}
}
