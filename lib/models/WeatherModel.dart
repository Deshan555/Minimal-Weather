class WeatherModel {
  final String cityName;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double visibility;
  final double windSpeed;
  final double windDegree;
  final String mainCondition;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.windDegree,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      visibility: json['visibility'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      windDegree: json['wind']['deg'].toDouble(),
    );
  }
}