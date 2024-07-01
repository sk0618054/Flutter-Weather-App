import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class WeatherDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    // Map weather condition to corresponding background image
    String getBackgroundImage(String condition) {
      if (condition.contains('sun')) {
        return 'assets/sunny.jpg';
      } else if (condition.contains('cloud')) {
        return 'assets/cloudy.jpg';
      } else if (condition.contains('rain')) {
        return 'assets/rainy.jpg';
      } else if (condition.contains('snow')) {
        return 'assets/snowy.jpg';
      } else {
        return 'assets/cloudy.jpg'; // Default background
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(weatherProvider.weather != null
                    ? getBackgroundImage(weatherProvider.weather!.condition.toLowerCase())
                    : 'assets/cloudy.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Weather details
          Column(
            children: [
              // Custom AppBar with Back Button
              Container(
                height: 80.0,
                padding: EdgeInsets.only(top: 40.0, left: 16.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Weather Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: weatherProvider.loading
                    ? Center(child: CircularProgressIndicator())
                    : weatherProvider.errorMessage != null
                    ? Center(child: Text(weatherProvider.errorMessage!))
                    : weatherProvider.weather != null
                    ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weatherProvider.weather!.cityName,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        color: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '${weatherProvider.weather!.temperature}°C',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                weatherProvider.weather!.condition,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                              Image.network(
                                'http://openweathermap.org/img/wn/${weatherProvider.weather!.icon}@2x.png',
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Humidity: ${weatherProvider.weather!.humidity}%',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Wind Speed: ${weatherProvider.weather!.windSpeed} m/s',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          weatherProvider.fetchWeather(
                              weatherProvider.weather!.cityName);
                        },
                        child: Text('Refresh'),
                      ),
                    ],
                  ),
                )
                    : Center(child: Text('No data')),
              ),
              // Display last searched city
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Last Searched City: ${weatherProvider.lastSearchedCity}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
