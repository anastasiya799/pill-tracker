import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/medication.dart';
import '../view_models/medication_list_view_model.dart';
import '../view_models/weather_view_model.dart';
import 'add_medication_screen.dart';
import 'medication_detail_screen.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicationListViewModel>().loadMedications();
      context.read<WeatherViewModel>().loadLastSearchedCity();
    });
  }

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

  void _deleteMedication(String medicationId, String medicationName) {
    final viewModel = context.read<MedicationListViewModel>();

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
                viewModel.deleteMedication(medicationId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"$medicationName" удалено'),
                    backgroundColor: Colors.red,
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

  void _searchWeather() {
    if (_cityController.text.isNotEmpty) {
      context.read<WeatherViewModel>().loadWeather(_cityController.text);
      _cityController.clear();
    }
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
            Text('Дозировка: ${medication.dosage}'),
            const SizedBox(height: 2),
            Text(
              'Время: ${medication.schedule.join(', ')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'details') {
              _viewMedicationDetails(medication);
            } else if (value == 'delete') {
              _deleteMedication(medication.id, medication.name);
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

  Widget _buildWeatherWidget(WeatherViewModel weatherViewModel) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌤️ Погода для напоминаний',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      hintText: 'Введите город...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _searchWeather(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _searchWeather,
                  icon: const Icon(Icons.search),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (weatherViewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (weatherViewModel.error != null)
              Text(
                'Ошибка: ${weatherViewModel.error}',
                style: const TextStyle(color: Colors.red),
              )
            else if (weatherViewModel.weatherData != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          weatherViewModel.currentCity ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${weatherViewModel.getTemperature()}°C',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weatherViewModel.getDescription()?.toUpperCase() ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              else
                const Text(
                  'Введите город для отображения погоды',
                  style: TextStyle(color: Colors.grey),
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicationViewModel = context.watch<MedicationListViewModel>();
    final weatherViewModel = context.watch<WeatherViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 Мои лекарства'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          if (medicationViewModel.error != null)
            IconButton(
              icon: const Icon(Icons.error, color: Colors.red),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка: ${medicationViewModel.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
        ],
      ),
      body: medicationViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : medicationViewModel.medications.isEmpty
          ? _buildEmptyState()
          : Column(
        children: [
          _buildWeatherWidget(weatherViewModel),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Мои лекарства (${medicationViewModel.medications.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    medicationViewModel.loadMedications();
                  },
                  child: const Text('Обновить'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await medicationViewModel.loadMedications();
                await weatherViewModel.loadLastSearchedCity();
              },
              child: ListView.builder(
                itemCount: medicationViewModel.medications.length,
                itemBuilder: (context, index) {
                  final medication = medicationViewModel.medications[index];
                  return _buildMedicationCard(medication);
                },
              ),
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

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}