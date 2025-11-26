import 'package:flutter/material.dart';
import '../models/medication.dart';
import 'add_medication_screen.dart';
import 'medication_detail_screen.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Medication> medications = [
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

  void _addNewMedication() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicationScreen(),
      ),
    );
  }

  void _viewMedicationDetails(Medication medication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationDetailScreen(medication: medication),
      ),
    );
  }

  void _deleteMedication(String medicationId) {
    setState(() {
      medications.removeWhere((med) => med.id == medicationId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Лекарство удалено'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _markAsTaken(Medication medication) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medication.name} отмечено как принятое'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String medicationId, String medicationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить лекарство?'),
          content: Text('Вы уверены, что хотите удалить "$medicationName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                _deleteMedication(medicationId);
                Navigator.pop(context);
              },
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              medication.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
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
            const SizedBox(height: 4),
            Text(
              'Дозировка: ${medication.dosage}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              'Время: ${medication.schedule.join(', ')}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'details') {
              _viewMedicationDetails(medication);
            } else if (value == 'taken') {
              _markAsTaken(medication);
            } else if (value == 'delete') {
              _showDeleteConfirmationDialog(medication.id, medication.name);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'details',
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20),
                  SizedBox(width: 8),
                  Text('Подробности'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'taken',
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 20, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Отметить как принятое'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Удалить'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _viewMedicationDetails(medication),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '💊',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          const Text(
            'Лекарств пока нет',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Добавьте первое лекарство,\nнажав на кнопку ниже',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addNewMedication,
            icon: const Icon(Icons.add),
            label: const Text('Добавить лекарство'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 Мои лекарства'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Поиск лекарств
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Функция поиска скоро будет доступна'),
                ),
              );
            },
          ),
        ],
      ),
      body: medications.isEmpty
          ? _buildEmptyState()
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Всего лекарств: ${medications.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];
                return _buildMedicationCard(medication);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewMedication,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}