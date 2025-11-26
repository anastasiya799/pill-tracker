import 'package:flutter/material.dart';
import '../models/medication.dart';

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о лекарстве'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с иконкой
            Center(
              child: Column(
                children: [
                  Text(
                    medication.icon,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    medication.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Информация о лекарстве
            _buildInfoRow('Дозировка', medication.dosage),
            _buildInfoRow('Тип', medication.type),

            const SizedBox(height: 16),

            // Расписание
            const Text(
              '📅 Расписание приема:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: medication.schedule.map((time) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 8),
                        Text(time),
                      ],
                    ),
                  ),
              ).toList(),
            ),

            const SizedBox(height: 16),

            // Примечания
            const Text(
              '📝 Примечания:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(medication.notes),

            const SizedBox(height: 32),

            // Кнопка удаления
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TO DO: Логика удаления
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.delete),
                label: const Text('Удалить лекарство'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}