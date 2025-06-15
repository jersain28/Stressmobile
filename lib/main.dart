import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stress/Screens/Auth/welcome.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stress',
      debugShowCheckedModeBanner: false,
       theme: ThemeData.light(), // Tema claro
      darkTheme: ThemeData.dark(), // Tema oscuro
      themeMode: ThemeMode.system, // Usa el tema del sistema
      home: const WelcomeScreen(),
    );
  }
}
