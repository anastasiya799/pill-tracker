import 'package:flutter/material.dart';
import 'screens/medication_list_screen.dart';
import 'screens/add_medication_screen.dart';
import 'screens/medication_detail_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MedicationListScreen(),
        '/add': (context) => AddMedicationScreen(),
      },
    );
  }
}