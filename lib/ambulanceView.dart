import 'package:flutter/material.dart';
import 'package:ambutime/db/ambulanceDb.dart';
import 'package:ambutime/db/emergencyRequestDb.dart';

Future<void> ambulanceConnect() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ambulancesDatabase.connect();
  await emergencyRequestsDb.connect();
}

class AmbulanceRoute extends StatelessWidget {
  const AmbulanceRoute({super.key});

  @override
  Widget build(BuildContext context) {
    ambulanceConnect();
    Future.delayed(Duration.zero, () => _askDriverName(context));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                TitleBar(),
                CurrentEmergency(),
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
              await ambulancesDatabase.connect();
              await ambulancesDatabase.insertDriverName(
                name, "null" // Replace with appropriate value if necessary
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
  const CurrentEmergency({super.key});

  @override
  State<CurrentEmergency> createState() => _CurrentEmergencyState();
}

class _CurrentEmergencyState extends State<CurrentEmergency> {
  String emergencyID = "None";
  String location = "";
  String eta = "";
  double distance = -1.0;
  String detail = "";
  int classification = -1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ContentText(text: "Emergency ID: $emergencyID"),
          ContentText(text: "Emergency location: $location"),
          ContentText(text: "ETA: $eta"),
          ContentText(text: "Distance: $distance"),
          ContentText(text: "Emergency details: $detail"),
          ContentText(text: "Emergency classification: $classification"),
        ],
      ),
    );
  }
}
