import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _loading = false;
  String? _errorMessage;
  String last="";
  String cur="";

  Weather? get weather => _weather;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  final WeatherService _weatherService = WeatherService();
  late SharedPreferences _prefs;
  String _lastSearchedCity = '';

  String get lastSearchedCity => _lastSearchedCity;

  WeatherProvider() {
    _initPrefs();
    _loadLastSearchedCity(); // Load last searched city on initialization
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadLastSearchedCity() async {
    _lastSearchedCity = _prefs.getString('lastSearchedCity') ?? '';
    notifyListeners();
  }

  Future<void> fetchWeather(String city) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _weatherService.fetchWeather(city);
      _weather = Weather.fromJson(data);
      _lastSearchedCity = city; // Update last searched city
      _prefs.setString('lastSearchedCity', _lastSearchedCity); // Save last searched city to SharedPreferences
    } catch (e) {
      _errorMessage = e.toString();
    }

    _loading = false;
    notifyListeners();


    last=cur;
    _lastSearchedCity=last;
    cur=city;
    print(last+" "+cur);
  }

  Future<void> refreshWeather() async {
    if (_lastSearchedCity.isNotEmpty) {
      await fetchWeather(_lastSearchedCity);
    }
  }
}
