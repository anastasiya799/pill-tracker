import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/medication.dart';
import '../view_models/medication_list_view_model.dart';

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

  final List<String> _availableTimes = ['08:00', '12:00', '18:00', '20:00'];

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Название лекарства',
                        border: OutlineInputBorder(),
                        hintText: 'Например: Аспирин',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Дозировка',
                        border: OutlineInputBorder(),
                        hintText: 'Например: 100 мг',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Тип лекарства',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedType, // ИСПРАВЛЕНО: value → initialValue
                      items: const [
                        DropdownMenuItem(value: 'таблетка', child: Text('Таблетка')),
                        DropdownMenuItem(value: 'капсула', child: Text('Капсула')),
                        DropdownMenuItem(value: 'сироп', child: Text('Сироп')),
                        DropdownMenuItem(value: 'инъекция', child: Text('Инъекция')),
                        DropdownMenuItem(value: 'мазь', child: Text('Мазь')),
                        DropdownMenuItem(value: 'капли', child: Text('Капли')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Время приема:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Выберите одно или несколько времен приема',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableTimes.map((time) => _buildTimeChip(time)).toList(),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Примечания и инструкции',
                        border: OutlineInputBorder(),
                        hintText: 'Например: Принимать после еды...',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMedication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Сохранить лекарство'),
              ),
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

  void _saveMedication() async {
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

    final newMedication = Medication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      type: _selectedType!,
      schedule: List.from(_selectedTimes)..sort(),
      notes: _notesController.text.trim(),
      icon: _getIconByType(_selectedType!),
    );

    final viewModel = context.read<MedicationListViewModel>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await viewModel.addMedication(newMedication);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${newMedication.name}" добавлено!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorDialog('Ошибка сохранения: $error');
      }
    }
  }

  String _getIconByType(String type) {
    switch (type) {
      case 'таблетка':
        return '💊';
      case 'капсула':
        return '🔴';
      case 'сироп':
        return '🥄';
      case 'инъекция':
        return '💉';
      case 'мазь':
        return '🧴';
      case 'капли':
        return '💧';
      default:
        return '💊';
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
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