import 'package:flutter/material.dart';

void main() {
  runApp(MedicineTrackerApp());
}

class MedicineTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can change this color to fit your app's theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MedicineTrackerHomePage(),
    );
  }
}

class MedicineTrackerHomePage extends StatefulWidget {
  @override
  _MedicineTrackerHomePageState createState() => _MedicineTrackerHomePageState();
}

class _MedicineTrackerHomePageState extends State<MedicineTrackerHomePage> {
  // You can declare variables and functions related to your medicine tracker here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Tracker'),
      ),
      body: Center(
        child: Text(
          'Welcome to Medicine Tracker App!',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
