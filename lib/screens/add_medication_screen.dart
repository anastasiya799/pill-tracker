import 'package:flutter/material.dart';

class AddMedicationScreen extends StatelessWidget {
  const AddMedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить лекарство'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Название лекарства',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Дозировка',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Тип',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'таблетка', child: Text('Таблетка')),
                DropdownMenuItem(value: 'капсула', child: Text('Капсула')),
                DropdownMenuItem(value: 'сироп', child: Text('Сироп')),
                DropdownMenuItem(value: 'инъекция', child: Text('Инъекция')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Время приема:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildTimeChip('08:00'),
                _buildTimeChip('12:00'),
                _buildTimeChip('18:00'),
                _buildTimeChip('20:00'),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Примечания',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Chip(
      label: Text(time),
      backgroundColor: Colors.blue[100],
    );
  }
}