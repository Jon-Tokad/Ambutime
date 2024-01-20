import 'package:flutter/material.dart';
import 'package:ambutime/db/ambulanceDb.dart';
import 'package:ambutime/db/emergencyRequestDb.dart';
import 'ambulanceView.dart';

Future<void> ambulanceConnect() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ambulancesDatabase.connect();
  await emergencyRequestsDb.connect();
}

class DispatchRoute extends StatelessWidget {
  const DispatchRoute({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ambulanceConnect();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(children: [
                TitleBar(),
                Row(
                  children: [],
                )
              ]),
            ),
          ),
        ));
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
