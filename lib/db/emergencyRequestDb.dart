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

  static Future<void> insertEmergencyDetail(String detail, String location,
      String time, String classification) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME_EM);
    await collection.insertOne({
      "location": location,
      "time": time,
      "detail": detail,
      "classification": classification
    });
  }

  static Future<List<Map<String, dynamic>>?>? pullEmergencies() async {
    inspect(database);
    var status = database!.serverStatus();
    var collection = database?.collection(COLLECTION_NAME_EM);
    return (await collection?.find().toList());
  }

  static Future<void> close() async {
    try {
      await database!.close();
    } catch (e) {
      log(e.toString());
    }
  }
}
