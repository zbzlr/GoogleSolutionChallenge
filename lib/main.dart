// main.dart
import 'package:flutter/material.dart';
import 'package:AquaPlan/screens/welcome_screen.dart';
import 'package:AquaPlan/database_helper.dart';
import 'package:AquaPlan/screens/planlarim.dart';
import 'package:intl/date_symbol_data_local.dart'; // Ekledik

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Gerekli olduğunda veritabanı bağlantısını başlatmak için
  DatabaseHelper().initDatabase(); // Veritabanı bağlantısını başlat
  initializeDateFormatting(
      'tr_TR', null); // Türkçe için yerel tarih biçimini başlatır
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
