import 'package:flutter/foundation.dart';
import '../../domain/models/medication.dart';
import '../../data/repositories/medication_repository.dart';

class MedicationListViewModel with ChangeNotifier {
  final MedicationRepository _repository = MedicationRepository();

  List<Medication> _medications = [];
  bool _isLoading = false;
  String? _error;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMedications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _medications = await _repository.getAllMedications();
    } catch (e) {
      _error = 'Ошибка загрузки: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication(Medication medication) async {
    try {
      await _repository.addMedication(medication);
      await loadMedications();
    } catch (e) {
      _error = 'Ошибка добавления: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      await _repository.deleteMedication(id);
      await loadMedications();
    } catch (e) {
      _error = 'Ошибка удаления: $e';
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Medication? getMedicationById(String id) {
    try {
      return _medications.firstWhere((med) => med.id == id);
    } catch (e) {
      return null;
    }
  }
}