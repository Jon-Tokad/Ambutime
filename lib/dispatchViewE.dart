import 'package:flutter/material.dart';
import 'package:ambutime/db/ambulanceDb.dart';
import 'package:ambutime/db/emergencyRequestDb.dart';
import 'ambulanceView.dart';
import 'package:ambutime/dispatchView.dart';
import 'package:ambutime/db/pairsDb.dart';

Future<List<Map<String, dynamic>>?> ambulanceConnect() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ambulancesDatabase.connect();
  return await ambulancesDatabase.pullAmbulances();
}

class DispatchRouteE extends StatelessWidget {
  const DispatchRouteE({super.key, required this.id});
  final String id;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme:
            ThemeData(primarySwatch: Colors.red, primaryColorLight: Colors.red),
        home: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text("Dispatch ambulances")),
          body: EmergencyList(id: id),
        ));
  }
}

class Emergency extends StatelessWidget {
  const Emergency(
      {super.key,
      required this.id,
      required this.location,
      required this.time,
      required this.detail,
      required this.classification,
      required this.name});
  final String id;
  final String location;
  final String time;
  final String detail;
  final String classification;
  final String name;
  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;

    if (classification == "-1") {
      textColor = Colors.grey;
    }

    return Column(
      children: [
        Text(
          "ID: $id",
          style: TextStyle(fontSize: 10, color: textColor),
        ),
        Text(
          "Name: $name",
          style: TextStyle(fontSize: 10, color: textColor),
        ),
        Text("Location: $location",
            style: TextStyle(fontSize: 10, color: textColor)),
        Text("Time: $time", style: TextStyle(fontSize: 10, color: textColor)),
        Text("Detail: $detail",
            style: TextStyle(fontSize: 10, color: textColor)),
        Text("Classification: $classification",
            style: TextStyle(fontSize: 10, color: textColor)),
        const Divider(
          color: Colors.black,
        )
      ],
    );
  }
}

class EmergencyList extends StatefulWidget {
  EmergencyList({super.key, required this.id});

  final String id;

  @override
  State<EmergencyList> createState() => _EmergencyListState();
}

class _EmergencyListState extends State<EmergencyList> {
  var emergencyList = [];

  void _getEmergencies() async {
    await emergencyRequestsDb.connect();
    var emergenciesListTmp = await emergencyRequestsDb.pullEmergencies();

    var objList = [];

    for (var item in emergenciesListTmp!) {
      objList.add({
        "id": item['_id'].toString(),
        "location": item['location'].toString(),
        "time": item['time'].toString(),
        "detail": item['detail'].toString(),
        "classification": item['classification'].toString(),
        "name": item['name'].toString()
      });
    }

    setState(() {
      emergencyList = objList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const TitleBar(),
          FloatingActionButton(
            onPressed: _getEmergencies,
            tooltip: 'refresh',
            child: const Icon(Icons.refresh),
          ),
          const Text("Select an emergency"),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: emergencyList.length,
              itemBuilder: (BuildContext context, int index) {
                var curID = emergencyList[index]["id"].toString();
                var curLoc = emergencyList[index]["location"].toString();
                var curTime = emergencyList[index]["time"].toString();
                var curDetail = emergencyList[index]["detail"].toString();
                var curName = emergencyList[index]["name"].toString();
                var curClass =
                    emergencyList[index]["classification"].toString();
                return ListTile(
                  title: Emergency(
                      id: curID,
                      time: curTime,
                      location: curLoc,
                      detail: curDetail,
                      classification: curClass,
                      name: curName),
                  onTap: () {
                    PairsDb.insertPair(widget.id, curName);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DispatchRoute()));
                  },
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
