import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';

Future<String> getLatitude() async {
  Location location = Location();
  LocationData? currentLocation;
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  try {
    LocationData locationData = await location.getLocation();
    currentLocation = locationData;
    latitudeController.text = currentLocation?.latitude.toString() ?? '';
    longitudeController.text = currentLocation?.longitude.toString() ?? '';
  } catch (e) {
    print("Error getting location: $e");
  }

  return latitudeController.text;
}

Future<String> getLongitude() async {
  Location location = Location();
  LocationData? currentLocation;
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  try {
    LocationData locationData = await location.getLocation();
    currentLocation = locationData;
    latitudeController.text = currentLocation?.latitude.toString() ?? '';
    longitudeController.text = currentLocation?.longitude.toString() ?? '';
  } catch (e) {
    print("Error getting location: $e");
  }

  return longitudeController.text;
}
