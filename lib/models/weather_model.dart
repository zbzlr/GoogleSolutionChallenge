class Weather {
  final String name;
  final Map<String, dynamic> main;
  final Map<String, dynamic> wind;
  final List<dynamic> weather;
  final double? rain; // Yağış miktarı bilgisini ekleyin
  final double? precipitationProbability; // Yağış olasılığı bilgisini ekleyin
  final DateTime dateTime; // Tahminin zamanını temsil eden özellik

  Weather({
    required this.name,
    required this.main,
    required this.weather,
    required this.wind,
    this.rain,
    this.precipitationProbability,
    required this.dateTime, // Zaman özelliğini ekleyin
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    var rainVolume = json['rain'] != null ? (json['rain']['1h'] ?? 0.0) : 0.0;
    var precipitationProbability =
        json['clouds'] != null ? (json['clouds']['all'] / 100.0) : null;

    // Unix zaman damgasını dönüştürmek için
    var dateTime = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);

    return Weather(
      name: json['name'],
      wind: json['wind'],
      weather: json['weather'],
      main: json['main'],
      rain: rainVolume,
      precipitationProbability: precipitationProbability,
      dateTime: dateTime,
    );
  }
}
