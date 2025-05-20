import 'package:flutter/material.dart';
import 'package:maimate_fixed/theme/theme.dart'; // HUOM: muokkaa polku projektin nimen mukaan
import 'package:maimate_fixed/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mAImate',
      debugShowCheckedModeBanner: false,
      theme: appTheme, // 🟦 Otetaan käyttöön safiiriteema
      home: const HomeScreen(),
    );
  }
}

