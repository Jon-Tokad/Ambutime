import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';
import 'dart:developer';

class emergencyRequestsDb {
  static Db? database;

  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(COLLECTION_NAME_EM);
    /*await collection.insertOne({
      "location": "null",
      "time": "1:21:00",
      "detail": "broken leg",
      "classification": 4
    });
    */
    print(await collection.find().toList());
    database = db;
  }


  static Future<void> insertEmergencyDetail(String detail) async {
    Db? database;
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var collection = database!.collection(COLLECTION_NAME_EM);
    await collection.insertOne({
      "detail": detail
    });
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
