import 'package:flutter/material.dart';
import '../models/medication.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedType;
  final List<String> _selectedTimes = [];

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
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название лекарства',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dosageController,
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
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: 'таблетка', child: Text('Таблетка')),
                DropdownMenuItem(value: 'капсула', child: Text('Капсула')),
                DropdownMenuItem(value: 'сироп', child: Text('Сироп')),
                DropdownMenuItem(value: 'инъекция', child: Text('Инъекция')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
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
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Примечания',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveMedication,
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
    final isSelected = _selectedTimes.contains(time);
    return GestureDetector(
      onTap: () => _toggleTime(time),
      child: Chip(
        label: Text(time),
        backgroundColor: isSelected ? Colors.blue[700] : Colors.blue[100],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  void _toggleTime(String time) {
    setState(() {
      if (_selectedTimes.contains(time)) {
        _selectedTimes.remove(time);
      } else {
        _selectedTimes.add(time);
      }
    });
  }

  void _saveMedication() {
    if (_nameController.text.isEmpty) {
      _showErrorDialog('Введите название лекарства');
      return;
    }

    if (_dosageController.text.isEmpty) {
      _showErrorDialog('Введите дозировку');
      return;
    }

    if (_selectedType == null) {
      _showErrorDialog('Выберите тип лекарства');
      return;
    }

    if (_selectedTimes.isEmpty) {
      _showErrorDialog('Выберите время приема');
      return;
    }

    Navigator.pop(context);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
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

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}