import 'package:flutter/material.dart';
import '../models/medication.dart';

class MedicationListScreen extends StatelessWidget {
  final List<Medication> medications = [
    Medication(
      id: '1',
      name: 'Аспирин',
      dosage: '100 мг',
      type: 'таблетка',
      schedule: ['08:00', '20:00'],
      notes: 'Принимать после еды',
      icon: '💊',
    ),
    Medication(
      id: '2',
      name: 'Витамин D',
      dosage: '2000 МЕ',
      type: 'капсула',
      schedule: ['12:00'],
      notes: 'Во время обеда',
      icon: '🌞',
    ),
    Medication(
      id: '3',
      name: 'Омега-3',
      dosage: '1000 мг',
      type: 'капсула',
      schedule: ['09:00', '21:00'],
      notes: 'После еды',
      icon: '🐟',
    ),
  ];

  MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 Мои лекарства'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Text(
                medication.icon,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                medication.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Дозировка: ${medication.dosage}'),
                  Text('Расписание: ${medication.schedule.join(', ')}'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TO DO: Навигация
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TO DO: Навигация
        },
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}