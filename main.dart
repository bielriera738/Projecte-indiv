import 'package:flutter/material.dart';
import 'lib/screens/menu.dart';

void main() {
  runApp(const NutriVisionApp());
}

class NutriVisionApp extends StatelessWidget {
  const NutriVisionApp({super.key});

  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriVision AI',
      theme: ThemeData(
        primaryColor: const Color(0xFF0B3D2E),
        scaffoldBackgroundColor: const Color(0xFF0B3D2E),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const MenuScreen(),
    );
  }
}
