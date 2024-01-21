import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';
import 'dart:developer';

class PairsDb {
  static Future<void> insertPair(
    String ambulanceID,
    String emergencyID,
  ) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME_P);
    await collection.insertOne({
      "ambulance": ambulanceID,
      "emergency": emergencyID,
    });

    collection = db.collection(COLLECTION_NAME_AMB);
    await collection.update(
        where.eq("name", ambulanceID), modify.set("available", false));

    collection = db.collection(COLLECTION_NAME_EM);
    await collection.update(
        where.eq("name", emergencyID), modify.set("classification", -1));
  }

  static Future<Map<String, dynamic>?> getAmbulance(
      String emergencyName) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME_P);
    var ambulanceName =
        await collection.findOne(where.eq("emergency", emergencyName));

    collection = db.collection(COLLECTION_NAME_AMB);

    return await collection.findOne(where.eq("ambulance", ambulanceName));
  }

  static Future<Map<String, dynamic>?> getEmergency(
      String ambulanceName) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME_P);
    var emergencyName =
        await collection.findOne(where.eq("ambulance", ambulanceName));

    collection = db.collection(COLLECTION_NAME_EM);

    return await collection.findOne(where.eq("emergency", emergencyName));
  }
}
