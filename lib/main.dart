import 'package:flutter/material.dart';
import 'package:tajjang/pages/p_homepage.dart';

void main() {
  runApp(const TaJJangApp());
}

class TaJJangApp extends StatelessWidget {
  const TaJJangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaJJang',
      theme: ThemeData(
        primaryColor: const Color(0xFF4AA9DE),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFB284)),
      ),
      home: const TaJJangHomePage(),
    );
  }
}
