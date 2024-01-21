import 'package:ambutime/citizenView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:ambutime/db/pairsDb.dart';


class MapRoute extends StatelessWidget {
  MapRoute({super.key, required this.name});

  final String name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromRGBO(243, 17, 17, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ambutime'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: 'Ambu',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black)),
          TextSpan(
              text: '+',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.red)),
          TextSpan(
              text: 'ime',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black)),
        ],
      ),
    );
  }
}

class MyLocationPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.location_on,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

class AmbulanceLocationPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.location_on,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

// for reference (not used)

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Location location = Location();
  LocationData? currentLocation;
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  var currentAmbulance = null;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    currentAmbulance = await PairsDb.getAmbulance(name);
    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
        latitudeController.text = currentLocation?.latitude.toString() ?? '';
        longitudeController.text = currentLocation?.longitude.toString() ?? '';
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }
 
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TitleBar(),
            const SizedBox(height: 20),
            const Text(
              'Help is on the way',
            ),
            const SizedBox(height: 30),
            CupertinoButton.filled(
              onPressed: () {},
              child: const Text('Enabled'),
            ),
            const SizedBox(height: 20),
            Text(
              'ETA: $_counter minutes',
            ),
            Expanded(
              child: 
                FlutterMap(
                  options: MapOptions(
                  initialCenter: LatLng(currentLocation!.latitude ?? 0, currentLocation!.longitude ?? 0),
                  initialZoom: 18.0,

                ),
                children: [
                  TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(currentLocation!.latitude ?? 0, currentLocation!.longitude ?? 0),
                        width: 30,
                        height: 30,
                        child: MyLocationPin(),
                      ),
                      Marker(
                        point: LatLng(double.parse(currentAmbulance!['latitude']), double.parse(currentAmbulance!['longitude'])),
                        width: 30,
                        height: 30,
                        child: AmbulanceLocationPin(),
                      ),
                    ],
                  ),
                  RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                ),
            ],
          ),
        ],
    )
            ,)
          ],
        ),
      ),
    );
  }
}
