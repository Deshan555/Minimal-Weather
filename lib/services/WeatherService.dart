import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/WeatherModel.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String API_KEY;

  WeatherService({
    required this.API_KEY
  });

  // That Dart Future is a way to handle asynchronous operations With OpenWeatherMap API
  Future<WeatherModel> getWeather(String cityName) async {
    final url = '$BASE_URL?q=$cityName&appid=$API_KEY&units=metric';
    try {
      final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY&units=metric'));
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error getting weather for location : ${url}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error getting weather for location : ${url}');
    }
  }

  // That Dart Future is a way to handle asynchronous operations With Geolocator API
  Future<String> getCurrentLocation() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Convert position to PlaceMark Object and get the locality
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      String? city =  placemarks[0].locality;
      return city ?? 'Colombo';
    }
    return '';
  }


}