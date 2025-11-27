import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/medication_list_screen.dart';
import 'presentation/view_models/medication_list_view_model.dart';
import 'presentation/view_models/weather_view_model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MedicationListViewModel()),
        ChangeNotifierProvider(create: (context) => WeatherViewModel()),
      ],
      child: MaterialApp(
        title: 'Pill Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MedicationListScreen(),
      ),
    );
  }
}