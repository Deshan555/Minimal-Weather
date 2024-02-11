import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/SuggestionModel.dart';
import 'package:weather_app/models/WeatherModel.dart';
import 'package:weather_app/pages/SuggestionPage.dart';
import 'package:weather_app/services/WeatherService.dart';

import '../services/SuggestionService.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

// Weather Page Model View To Display Weather Information
class _WeatherPageState extends State<WeatherPage> {
  final _weatherService =
      WeatherService(API_KEY: 'f3b95358388162e9128e63eb894f403c');
  final _suggestionService = SuggestionService();
  String lastFetchTime = '';
  WeatherModel? _weather;
  SuggestionsModel? _suggestions;

  _featchWeather() async {
    final cityName = await _weatherService.getCurrentLocation();
    final weather = await _weatherService.getWeather(cityName);
    try {
      final weather = await _weatherService.getWeather(cityName);
      lastFetchTime = DateTime.now().toString();
      setState(() {
        _weather = weather;
      });
    } catch (exception) {
      throw Exception('Error getting weather for location : $exception');
    }
  }

  _fetchSuggestions() async {
    const personType = 'Student';
    final cityName = await _weatherService.getCurrentLocation();
    final condition = _weather?.mainCondition ?? 'Clouds';
    try {
      final suggestions = await _suggestionService.getOpenAIResponse(
          personType, cityName, condition);
      setState(() {
        _suggestions = suggestions;
      });
    } catch (exception) {
      throw Exception('Error getting suggestions for location : $exception');
    }
  }

  // Load Weather Animation Based on the Weather Condition
  String getWeatherAnimation(String mainCondition) {
    if (mainCondition == null) {
      return 'assets/cloudy.json';
    }
    switch (mainCondition) {
      case 'Sunny':
        return 'assets/sunny.json';
      case 'Clouds':
      case 'Mist':
        return 'assets/cloudy.json';
      case 'Rain':
      case 'Drizzle':
        return 'assets/light-shower.json';
      case 'Thunderstorm':
        return 'assets/thunderstorm.json';
      case 'Clear':
        return 'assets/sunny.json';
      default:
        return 'assets/cloudy.json';
    }
  }

  // initState() is called once when the widget is first created and fetched the weather data
  @override
  void initState() {
    super.initState();
    _featchWeather();
    //_fetchSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _weather == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/loading.json'),
                      const Text(
                        'Loading Weather Data ...',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 25.0,
                ),
          Text(
            _weather?.cityName.toUpperCase() ?? 'Loading City Data ...',
            style: GoogleFonts.robotoCondensed(
              fontSize: 21.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          Center(
            child: Lottie.asset(
              getWeatherAnimation(_weather!.mainCondition),
            ),
          ),
          Text(
            'Last Updated: $lastFetchTime',
            style: GoogleFonts.robotoCondensed(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFeatures: [const FontFeature.enable('smcp')], // optional
            ),
          ),
          // Display temperature
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              '${_weather?.temperature.round()}°C',
              style: GoogleFonts.robotoCondensed(
                fontSize: 70.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFeatures: [const FontFeature.enable('smcp')], // optional
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      onPressed:
                      _featchWeather();
                    },
                    icon: const Icon(Icons.refresh),
                    color: Colors.white,
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navigate to the Suggestion page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SuggestionPage(
                              // todo: pass the weather condition and city name to the suggestion page
                                  weatherCondition: 'Sunny',
                                  city: 'Colombo',
                                )),
                      );
                    },
                    icon: const Icon(Icons.lightbulb),
                    color: Colors.white,
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      onPressed:
                      _fetchSuggestions;
                    },
                    icon: const Icon(Icons.info),
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
