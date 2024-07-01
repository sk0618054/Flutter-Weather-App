import 'dart:convert';
import 'dart:io'; // Import for SocketException
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'efc2fd2391b13a54fa3a2e5a3056bac4'; // Replace with your actual API key
  static const String _baseUrl = 'http://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?q=$city&units=metric&appid=$_apiKey'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather data');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to load weather data');
    }
  }
}
