import 'dart:isolate';

import 'package:ambutime/db/ambulanceDb.dart';
import 'package:ambutime/locator.dart';
import 'package:flutter/material.dart';
import 'mapView.dart';
import 'db/emergencyRequestDb.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class TitleBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: const <TextSpan>[
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

class CitizenRoute extends StatelessWidget {
  const CitizenRoute({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 172, 2, 2)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ambutime'),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  // Function to show dialog when SOS button is pressed
  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Emergency Alert'),
          content: Text('Emergency responders are on the way.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                await emergencyRequestsDb.insertEmergencyDetail(
                    "SOS" + DateTime.now().toString() + await getLatitude(),
                    DateTime.now().toString(),
                    "SOS",
                    "SOS",
                    await getLatitude(),
                    await getLongitude() // Replace with appropriate value if necessary
                    );
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MapRoute()));
              },
            ),
          ],
        );
      },
    );
  }

  void _phys() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Physical Health Resources'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  child: Text('NIH Resources'),
                  onTap: () => launch(
                      'https://www.nih.gov/health-information/physical-wellness-toolkit-more-resources'),
                ),
                SizedBox(height: 10), // Space between links
                InkWell(
                  child: Text('CDC Health Tips'),
                  onTap: () =>
                      launch('https://www.cdc.gov/healthyweight/index.html'),
                ),
                SizedBox(height: 10),
                InkWell(
                  child: Text('WHO Resources'),
                  onTap: () => launch(
                      'https://www.who.int/health-topics/physical-activity'),
                ),
                // Add more links here in the same pattern
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _ment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mental Health Resources'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  child: Text('SAMHSA'),
                  onTap: () => launch('https://www.samhsa.gov'),
                ),
                SizedBox(height: 10), // Space between links
                InkWell(
                  child: Text('National Institute of Mental Health'),
                  onTap: () =>
                      launch('https://www.nimh.nih.gov/health/find-help'),
                ),
                SizedBox(height: 10),
                InkWell(
                  child: Text('Purdue Mental Health Resources'),
                  onTap: () => launch(
                      'https://www.purdue.edu/lgbtq/resources/health/mental-health.php'),
                ),
                // Add more links here in the same pattern
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _desc() {
    TextEditingController _emergencyDetailController = TextEditingController();
    TextEditingController _currentTimeController = TextEditingController();
    TextEditingController _categoryController = TextEditingController();
    TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Describe Your Emergency'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please provide emergency details:'),
                TextFormField(
                  controller: _emergencyDetailController,
                  decoration:
                      InputDecoration(hintText: "Enter emergency details here"),
                ),
                SizedBox(height: 10),
                Text('Enter current time:'),
                TextFormField(
                  controller: _currentTimeController,
                  decoration:
                      InputDecoration(hintText: "Enter current time here"),
                ),
                SizedBox(height: 10),
                Text('Enter emergency category:'),
                TextFormField(
                  controller: _categoryController,
                  decoration:
                      InputDecoration(hintText: "Enter category number here"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                Text('Enter emergency name:'),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Enter name here"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Send Information'),
              onPressed: () async {
                String detail = _emergencyDetailController.text;
                String currentTime = _currentTimeController.text;
                String category = _categoryController.text;
                String name = _nameController.text;
                print(detail);
                print(currentTime);
                print(category);

                await ambulancesDatabase.connect();
                await emergencyRequestsDb.insertEmergencyDetail(
                    detail,
                    DateTime.now().toString(),
                    category,
                    name,
                    await getLatitude(),
                    await getLongitude() // Replace with appropriate value if necessary
                    );

                Navigator.of(context).pop(); // Close the input dialog

                // Display confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Notice'),
                      content: Text(
                          'Your Emergency Information Was Sent. Help Is On The Way.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            // Closes the Notice dialog
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MapRoute()));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: TitleBar()), // Using TitleBar here
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _phys,
              child: Text('Physical Health Resources'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                textStyle: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(height: 30), // Spacing between buttons
            ElevatedButton(
              onPressed: _ment,
              child: Text('Mental Health Resources'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                textStyle: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _desc,
              child: Text('Describe Your Emergency'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                textStyle: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
                height:
                    30), // Spacing between buttons // Spacing between buttons
            RawMaterialButton(
              onPressed: _showEmergencyDialog,
              child: SOSBtn(),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: null,
              child: Text(
                'Warning: Pressing the SOS button will call an ambulance and send the nature of your emergency along with your current location',
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                textStyle: TextStyle(fontSize: 10),
              ),
            ),
            // Add more buttons here if needed
          ],
        ),
      ),
    );
  }
}

class SOSBtn extends StatelessWidget {
  const SOSBtn({super.key});

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Container(
              width: 165,
              height: 165,
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 0, 0),
                      Color.fromARGB(255, 255, 172, 172)
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(80.0)))),
        ),
        Center(
          child: Container(
              width: 155,
              height: 155,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(80.0)))),
        ),
        Center(
          child: Container(
              width: 149,
              height: 149,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 0, 0),
                      Color.fromARGB(255, 255, 172, 172)
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(80.0)))),
        ),
        const Text(
          "SOS",
          style: TextStyle(
              fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
