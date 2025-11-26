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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Редактирование лекарства
              _showEditDialog(context);
            },
          ),
        ],
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
            _buildInfoCard(
              children: [
                _buildInfoRow('Дозировка', medication.dosage),
                _buildInfoRow('Тип', _getTypeDisplayName(medication.type)),
                _buildInfoRow('ID', medication.id),
              ],
            ),

            const SizedBox(height: 16),

            // Расписание
            _buildInfoCard(
              title: '📅 Расписание приема:',
              children: [
                Column(
                  children: medication.schedule.map((time) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Примечания
            _buildInfoCard(
              title: '📝 Примечания:',
              children: [
                Text(
                  medication.notes.isNotEmpty ? medication.notes : 'Нет примечаний',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Кнопки действий
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({String? title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
            ],
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Кнопка отметить как принятое
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _showTakenDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.check_circle),
            label: const Text('Отметить как принятое'),
          ),
        ),
        const SizedBox(height: 12),

        // Кнопка удаления
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _showDeleteDialog(context);
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
    );
  }

  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'таблетка':
        return 'Таблетка';
      case 'капсула':
        return 'Капсула';
      case 'сироп':
        return 'Сироп';
      case 'инъекция':
        return 'Инъекция';
      default:
        return type;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить лекарство?'),
          content: Text('Вы уверены, что хотите удалить "${medication.name}"? Это действие нельзя отменить.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Логика удаления лекарства
                Navigator.pop(context);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${medication.name}" удалено'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showTakenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Приём отмечен'),
          content: Text('Лекарство "${medication.name}" отмечено как принятое.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактирование'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}