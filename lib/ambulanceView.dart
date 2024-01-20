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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ambulanceConnect();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(children: [
                TitleBar(),
                const CurrentEmergency(),
              ]),
            ),
          ),
        ));
  }
}

class TitleBar extends StatelessWidget {
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

class ContentText extends StatelessWidget {
  const ContentText({super.key, required this.text});

  final String text;

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
          ContentText(text: "Emergency classification: $classification")
        ],
      ),
    );
  }
}
