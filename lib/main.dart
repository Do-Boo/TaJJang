import 'package:flutter/material.dart';
import 'package:tajjang/pages/p_setting_page.dart';
// import 'package:flutter/rendering.dart';
// import 'package:tajjang/pages/p_homepage.dart';
// import 'package:tajjang/pages/p_login_page.dart';
// import 'package:tajjang/pages/p_main_page.dart';
// import 'package:tajjang/pages/p_typing_test_launch_page.dart';
// import 'package:tajjang/pages/p_word_typing_test_page.dart';

void main() {
  runApp(const TaJJangApp());
}

class TaJJangApp extends StatelessWidget {
  const TaJJangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SettingsPage(),
    );
  }
}
