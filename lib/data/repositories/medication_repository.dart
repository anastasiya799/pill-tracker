import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/medication.dart';

class MedicationRepository {
  static const String _medicationsKey = 'medications';

  Future<List<Medication>> getAllMedications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final medicationsData = prefs.getStringList(_medicationsKey) ?? [];

      return medicationsData.map((json) {
        final map = _parseSimpleJson(json);
        return Medication.fromMap(map);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addMedication(Medication medication) async {
    try {
      final medications = await getAllMedications();
      medications.add(medication);
      await _saveAllMedications(medications);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      final medications = await getAllMedications();
      final index = medications.indexWhere((med) => med.id == medication.id);
      if (index != -1) {
        medications[index] = medication;
        await _saveAllMedications(medications);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      final medications = await getAllMedications();
      final initialLength = medications.length;
      medications.removeWhere((med) => med.id == id);

      if (medications.length < initialLength) {
        await _saveAllMedications(medications);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveAllMedications(List<Medication> medications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final medicationsData = medications.map((med) {
        final map = med.toMap();
        return _convertMapToString(map);
      }).toList();

      await prefs.setStringList(_medicationsKey, medicationsData);
    } catch (e) {
      rethrow;
    }
  }

  String _convertMapToString(Map<String, dynamic> map) {
    final buffer = StringBuffer();
    buffer.write('{');

    var first = true;
    map.forEach((key, value) {
      if (!first) buffer.write(', ');
      first = false;

      if (value is List) {
        buffer.write('$key: [${value.join(',')}]');
      } else {
        buffer.write('$key: $value');
      }
    });

    buffer.write('}');
    return buffer.toString();
  }

  Map<String, dynamic> _parseSimpleJson(String jsonString) {
    try {
      final cleaned = jsonString.replaceAll('{', '').replaceAll('}', '');
      final parts = cleaned.split(', ');

      final Map<String, dynamic> result = {};

      for (final part in parts) {
        final keyValue = part.split(': ');
        if (keyValue.length == 2) {
          final key = keyValue[0].trim();
          var value = keyValue[1].trim();

          if (value.startsWith('[') && value.endsWith(']')) {
            value = value.replaceAll('[', '').replaceAll(']', '');
            result[key] = value.split(',');
          } else {
            result[key] = value;
          }
        }
      }

      return result;
    } catch (e) {
      return {};
    }
  }

  Future<void> clearAllMedications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_medicationsKey);
    } catch (e) {
      rethrow;
    }
  }
}