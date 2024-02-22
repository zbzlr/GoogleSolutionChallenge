import 'package:flutter/material.dart';
import 'package:AquaPlan/screens/home_screen.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(198, 135, 100, 100),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Merhaba',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontFamily: 'Arial', // Örnek bir font
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Hoş Geldiniz',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Arial', // Örnek bir font
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            Container(
              height: 240,
              width: 240,
              child: Lottie.asset(
                'assets/wheat.json',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
