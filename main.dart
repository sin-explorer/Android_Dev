import 'package:flutter/material.dart';
import 'package:project/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      title: 'Hi5A! Survey App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 75, 106, 255), // Adjusted alpha value
        backgroundColor:
            Color.fromARGB(255, 243, 247, 255), // Adjusted alpha value
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
