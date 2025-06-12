import 'package:flutter/material.dart';
import 'package:stress/Screens/Auth/welcome.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stress',
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(), 
    );
  }
}