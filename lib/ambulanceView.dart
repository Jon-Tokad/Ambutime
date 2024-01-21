import 'package:flutter/material.dart';
import 'package:ambutime/db/ambulanceDb.dart';
import 'package:ambutime/db/emergencyRequestDb.dart';
import 'package:ambutime/locator.dart';
import 'package:ambutime/db/pairsDb.dart';

Future<void> ambulanceConnect() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ambulancesDatabase.connect();
  await emergencyRequestsDb.connect();
}

class AmbulanceRoute extends StatelessWidget {
  AmbulanceRoute({super.key});

  String driverName = "";

  @override
  Widget build(BuildContext context) {
    ambulanceConnect();
    Future.delayed(Duration.zero, () => _askDriverName(context));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                TitleBar(),
                CurrentEmergency(driverName: driverName),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _askDriverName(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Driver Name"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Name"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () async {
                String name = _nameController.text;
                driverName = name;
                await ambulancesDatabase.connect();
                await ambulancesDatabase.insertDriverName(
                    name,
                    await getLatitude(),
                    await getLongitude() // Replace with appropriate value if necessary
                    );
                // Use _nameController.text to get the entered name
                // You can store or use this name as needed
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
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
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: '+',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.red,
            ),
          ),
          TextSpan(
            text: 'ime',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ContentText extends StatelessWidget {
  const ContentText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }
}

class CurrentEmergency extends StatefulWidget {
  CurrentEmergency({super.key, required this.driverName});
  final String driverName;

  @override
  State<CurrentEmergency> createState() => _CurrentEmergencyState();
}

class _CurrentEmergencyState extends State<CurrentEmergency> {
  String emergencyID = "None";
  String location = "";
  String eta = "";
  String distance = "-1.0";
  String detail = "";
  String classification = "-1";
  String time = "";

  void getCurrentEmergency() async {
    var emergency = await PairsDb.getEmergency(widget.driverName);
    setState(() {
      emergencyID = emergency!['name'].toString();
      location = "(" +
          emergency!['latitude'].toString() +
          "," +
          emergency!['longitude'].toString() +
          ")";
      distance = emergency!['distance'].toString();
      detail = emergency!['detail'].toString();
      classification = emergency!['classification'].toString();
      time = emergency!['time'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          FloatingActionButton(
            onPressed: getCurrentEmergency,
            tooltip: 'refresh',
            child: const Icon(Icons.refresh),
          ),
          ContentText(text: "Emergency ID: $emergencyID"),
          ContentText(text: "Emergency location: $location"),
          ContentText(text: "ETA: $eta"),
          ContentText(text: "Distance: $distance"),
          ContentText(text: "Emergency details: $detail"),
          ContentText(text: "Emergency classification: $classification"),
          ContentText(text: "Time reported: $time"),
        ],
      ),
    );
  }
}
