import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ambutime/db/ambulanceDb.dart';
import 'package:ambutime/db/emergencyRequestDb.dart';
import 'ambulanceView.dart';

Future<List<Map<String, dynamic>>?> ambulanceConnect() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ambulancesDatabase.connect();
  return await ambulancesDatabase.pullAmbulances();
}

class DispatchRoute extends StatelessWidget {
  const DispatchRoute({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
          body: AmbulanceList(),
          /*Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(children: [
                TitleBar(),
                Row(
                  children: [AmbulanceList()],
                )
              ]),
            ),
          ),*/
        ));
  }
}

class Ambulance extends StatelessWidget {
  const Ambulance(
      {super.key,
      required this.id,
      required this.available,
      required this.location});
  final String id;
  final String available;
  final String location;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentText(text: id),
        ContentText(text: available),
        ContentText(text: location)
      ],
    );
  }
}

class AmbulanceList extends StatefulWidget {
  const AmbulanceList({super.key});

  @override
  State<AmbulanceList> createState() => _AmbulanceListState();
}

class _AmbulanceListState extends State<AmbulanceList> {
  var ambulanceList = [];

  void _getAmbulances() async {
    await ambulancesDatabase.connect();
    var ambulanceListtmp = await ambulancesDatabase.pullAmbulances();

    var objList = [];

    for (var item in ambulanceListtmp!) {
      objList.add({
        "id": item['_id'].toString(),
        "available": item['available'].toString(),
        "location": item['location'].toString(),
      });
    }

    setState(() {
      ambulanceList = objList;
      print(ambulanceList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: _getAmbulances,
            tooltip: 'Increment',
            child: const Icon(Icons.refresh),
          ),
          Text("Ambulances"),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ambulanceList.length,
              itemBuilder: (BuildContext context, int index) {
                var curID = ambulanceList[index]["id"].toString();
                var curAv = ambulanceList[index]["available"].toString();
                var curLoc = ambulanceList[index]["location"].toString();
                return ListTile(
                  title: Text(
                    "ID: $curID",
                    style: TextStyle(fontSize: 10),
                  ),
                  subtitle: Text("Availability: $curAv",
                      style: TextStyle(fontSize: 10)),
                  trailing: Text(
                    "Location: $curLoc",
                    style: TextStyle(fontSize: 10),
                  ),
                );
              })
        ],
      ),
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
