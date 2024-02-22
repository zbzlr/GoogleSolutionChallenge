import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Ekledik
import 'package:lottie/lottie.dart';
import 'package:AquaPlan/screens/planlarim.dart';

import '../city_coordinates.dart';
import '../models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Weather> myWeather;
  TextEditingController searchController = TextEditingController();
  bool isDefaultCitySelected = true; // Varsayılan şehir seçildi mi?

  Future<Weather> fetchWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&APPID=e9eeadc7975162acc4e8b8cac75ad192"));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Veriler yüklenemedi...');
    }
  }

  Future<String> getWeatherAnimationCode(String weatherCode) {
    switch (weatherCode) {
      case 'Clear':
        return Future.value('assets/clear.json');
      case 'Clouds':
        return Future.value('assets/clouds.json');
      case 'Haze':
        return Future.value('assets/haze.json');
      case 'Rain':
        return Future.value('assets/rain.json');
      case 'Snow':
        return Future.value('assets/snow.json');
      case 'Warning':
        return Future.value('assets/warning.json');
      default:
        return Future.value(
            'assets/clear.json'); // Varsayılan olarak clear.json göster
    }
  }

  Future<Weather> fetchWeatherByCityName(String cityName) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=e9eeadc7975162acc4e8b8cac75ad192"));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Veriler yüklenemedi...');
    }
  }

  @override
  void initState() {
    super.initState();
    final coordinates = CityCoordinates.getCoordinates("İSTANBUL");
    myWeather = fetchWeather(coordinates["lat"]!, coordinates["longitude"]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(138, 205, 226, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              SafeArea(
                top: true,
                child: Column(
                  children: [
                    SizedBox(height: 1),
                    SizedBox(height: 1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: TextField(
                        controller: searchController,
                        enabled: true,
                        decoration: InputDecoration(
                          hintText: 'Şehir arayın...',
                          hintStyle: TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search, color: Colors.black),
                            onPressed: () async {
                              String cityName = searchController.text;
                              myWeather = fetchWeatherByCityName(cityName);
                              setState(() {});
                            },
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 6),
                    Expanded(
                      child: FutureBuilder<Weather>(
                        future: myWeather,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Veriler yüklenemedi..',
                              style: TextStyle(color: Colors.black),
                            );
                          } else if (snapshot.hasData) {
                            Weather weather = snapshot.data!;
                            double precipitationProbability =
                                _calculatePrecipitationProbability(
                                    weather.rain ?? 0.0);
                            bool isRainBelow50Percent =
                                precipitationProbability < 15;

                            return ListView(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weather.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      weather.weather[0]['main'].toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    SizedBox(height: 7),
                                    FutureBuilder<String>(
                                      future: getWeatherAnimationCode(
                                          weather.weather[0]['main']),
                                      builder: (context, animationSnapshot) {
                                        if (animationSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          );
                                        } else if (animationSnapshot.hasError) {
                                          return Text(
                                            'Animasyon yüklenemedi..',
                                            style:
                                                TextStyle(color: Colors.black),
                                          );
                                        } else if (animationSnapshot.hasData) {
                                          return Container(
                                            height: 110,
                                            width: 110,
                                            child: Lottie.asset(
                                              animationSnapshot.data!,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            'Animasyon yüklenemedi..',
                                            style:
                                                TextStyle(color: Colors.black),
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      DateFormat.yMMMMd('tr_TR')
                                          .format(DateTime.now()),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 2), // Bu satırı ekledim
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Yağış Miktarı',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '${weather.rain} mm',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 21,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 50),
                                        Column(
                                          children: [
                                            Text(
                                              'Yağış Oranı',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${precipitationProbability.toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 21,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Sıcaklık',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${((weather.main['temp'] - 32 * 5) / 9).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 21,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 50),
                                        Column(
                                          children: [
                                            Text(
                                              'Rüzgar',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${weather.wind['speed']} km/h',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 21,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 50),
                                        Column(
                                          children: [
                                            Text(
                                              'Nem',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${weather.main['humidity']}%',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 21,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 900,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                20), // Yatay yönde boşluk bırakmayı istemiyorsanız, `vertical` parametresini kullanabilirsiniz.
                                        child: Column(
                                          children: [
                                            Text(
                                              isRainBelow50Percent
                                                  ? "\n Merhaba her şey yolunda, tarla sulama \n işlemi yapabilirsiniz."
                                                  : "\n DİKKAT ⚠️ %15 ve üstü oranında yağış \n bekleniyor. Planınızda güncelleme \n yapmanızı tavsiye ederiz.",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlanlarimScreen(
                                                      defaultCity: "İstanbul")),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromRGBO(240, 139, 85, 0.612),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        'PLANLARIM',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Text(
                              'Veriler yüklenemedi..',
                              style: TextStyle(color: Colors.black),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculatePrecipitationProbability(double rainAmount) {
    if (rainAmount >= 4.0) {
      return 100.0;
    } else if (rainAmount >= 2.0) {
      return 50.0 + ((rainAmount - 2.0) / 2.0) * 50.0;
    } else {
      return (rainAmount / 2.0) * 50.0;
    }
  }
}
