import 'package:flutter/foundation.dart';
import '../../data/repositories/weather_repository.dart';

class WeatherViewModel with ChangeNotifier {
  final WeatherRepository _repository = WeatherRepository();

  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _error;
  String? _currentCity;

  Map<String, dynamic>? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentCity => _currentCity;

  Future<void> loadWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weatherData = await _repository.getWeather(city);
      _currentCity = city;
    } catch (e) {
      _error = 'Ошибка загрузки погоды: $e';
      _weatherData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLastSearchedCity() async {
    _currentCity = await _repository.getLastSearchedCity();
    if (_currentCity != null) {
      await loadWeather(_currentCity!);
    }
  }

  String? getTemperature() {
    if (_weatherData?['main'] != null) {
      return _weatherData!['main']['temp'].round().toString();
    }
    return null;
  }

  String? getDescription() {
    if (_weatherData?['weather'] != null && _weatherData!['weather'].isNotEmpty) {
      return _weatherData!['weather'][0]['description'];
    }
    return null;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}