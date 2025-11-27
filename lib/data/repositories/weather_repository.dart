import '../services/weather_service.dart';

class WeatherRepository {
  final WeatherService _weatherService = WeatherService();

  Future<Map<String, dynamic>> getWeather(String city) async {
    await _weatherService.saveLastSearchedCity(city);
    return await _weatherService.getWeatherByCity(city);
  }

  Future<String?> getLastSearchedCity() async {
    return await _weatherService.getLastSearchedCity();
  }
}