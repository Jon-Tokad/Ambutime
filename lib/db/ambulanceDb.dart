import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';
import 'dart:developer';

class ambulancesDatabase {
  static Db? database;

  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(COLLECTION_NAME_AMB);
    await collection.insertOne({"available": true, "location": "null"});
    print(await collection.find().toList());
    database = db;
  }

  static Future<void> close() async {
    try {
      await database!.close();
    } catch (e) {
      log(e.toString());
    }
  }
}
