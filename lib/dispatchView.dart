import 'package:ambutime/dispatchViewE.dart';
import 'package:flutter/material.dart';
import 'package:ambutime/db/ambulanceDb.dart';
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
        theme:
            ThemeData(primarySwatch: Colors.red, primaryColorLight: Colors.red),
        home: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text("Dispatch ambulances")),
          body: const AmbulanceList(),
        ));
  }
}

class Ambulance extends StatelessWidget {
  const Ambulance(
      {super.key,
      required this.id,
      required this.available,
      required this.location,
      required this.name});
  final String id;
  final String available;
  final String location;
  final String name;
  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;

    if (available == "false") {
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
        Text("Availability: $available",
            style: TextStyle(fontSize: 10, color: textColor)),
        Text("Location: $location",
            style: TextStyle(fontSize: 10, color: textColor)),
        const Divider(
          color: Colors.black,
        )
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
        "name": item['name'].toString(),
      });
    }

    setState(() {
      ambulanceList = objList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const TitleBar(),
          FloatingActionButton(
            onPressed: _getAmbulances,
            tooltip: 'refresh',
            child: const Icon(Icons.refresh),
          ),
          const Text("Select an ambulance"),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ambulanceList.length,
              itemBuilder: (BuildContext context, int index) {
                var curID = ambulanceList[index]["id"].toString();
                var curAv = ambulanceList[index]["available"].toString();
                var curLoc = ambulanceList[index]["location"].toString();
                var curName = ambulanceList[index]["name"].toString();

                return ListTile(
                  title: Ambulance(
                      id: curID,
                      available: curAv,
                      location: curLoc,
                      name: curName),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DispatchRouteE(id: curName)));
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
