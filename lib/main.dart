import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MedicineTrackerApp());
}

class Medicine {
  String name;
  String dosage;
  Map<String, List<String>> weeklySchedule; // Day of the week to list of times

  Medicine({required this.name, required this.dosage, required this.weeklySchedule});
}

class MedicineTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Tracker',
      theme: ThemeData.light(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static List<Medicine> medicineList = [];

  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      DailyMedicineTab(medicines: medicineList),
      AddMedicineTab(onAddMedicine: (medicine) {
        setState(() {
          medicineList.add(medicine);
        });
      }),
      SettingsTab(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Tracker'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DailyMedicineTab extends StatelessWidget {
  final List<Medicine> medicines;

  DailyMedicineTab({required this.medicines});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      eventLoader: (day) {
        var medicinesToday = <String>[];
        medicines.forEach((medicine) {
          medicine.weeklySchedule[DateFormat('EEEE').format(day)]?.forEach((time) {
            medicinesToday.add('${medicine.name} at $time');
          });
        });
        return medicinesToday;
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: _buildEventsMarker(date, events),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List<dynamic> events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue[700],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}

class AddMedicineTab extends StatefulWidget {
  final Function(Medicine) onAddMedicine;

  AddMedicineTab({required this.onAddMedicine});

  @override
  _AddMedicineTabState createState() => _AddMedicineTabState();
}

class _AddMedicineTabState extends State<AddMedicineTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  Map<String, List<String>> _weeklySchedule = {};

  void _addMedicine() {
    if (_weeklySchedule.isEmpty) {
      _showSnackbar("Please set at least one time.");
      return;
    }
    final medicine = Medicine(
      name: _nameController.text,
      dosage: _dosageController.text,
      weeklySchedule: _weeklySchedule,
    );
    widget.onAddMedicine(medicine);

    // Make sure to check if the current state is mounted before popping
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _pickTime(String day) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _weeklySchedule.putIfAbsent(day, () => []).add(time.format(context));
      });
    }
  }

  void _showSnackbar(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Medicine name"),
          ),
          TextField(
            controller: _dosageController,
            decoration: InputDecoration(hintText: "Dosage"),
          ),
          ...["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"].map(
                (day) => ListTile(
              title: Text(day),
              trailing: ElevatedButton(
                onPressed: () => _pickTime(day),
                child: Text('Set Time'),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addMedicine,
            child: Text('Add Medicine'),
          ),
        ],
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Settings Placeholder"),
    );
  }
}
