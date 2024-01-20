import 'package:flutter/material.dart';

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
              onPressed: () {
                Navigator.of(context).pop();
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
          title: Text('Physical Health Resouces'),
          content: Text('Add details here'),
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
          content: Text('Add details here'),
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
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Describe Your Emergency'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please provide details:'),
                TextFormField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                      hintText: "Enter your emergency details here"),
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
              onPressed: () {
                // Use _textFieldController.text to get the input data
                // Code to handle the input data goes here

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
                            // Popping the context twice to close both dialogs
                            Navigator.of(context)
                                .pop(); // Closes the Notice dialog
                            Navigator.of(context, rootNavigator: true)
                                .pop(); // Closes the Emergency Details dialog
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 30), // Spacing between buttons
            ElevatedButton(
              onPressed: _ment,
              child: Text('Mental Health Resources'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _desc,
              child: Text('Describe Your Emergency'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
                height:
                    30), // Spacing between buttons // Spacing between buttons
            ElevatedButton(
              onPressed: _showEmergencyDialog,
              child: Text('SOS'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
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
