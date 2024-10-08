import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajjang/pages/p_homepage.dart';
import 'package:tajjang/pages/p_profile_page.dart';
import 'package:tajjang/pages/p_profile_settings_page.dart';
import 'package:tajjang/pages/p_setting_page.dart';
import 'package:tajjang/pages/p_typing_test_launch_page.dart';
import 'package:tajjang/pages/p_word_typing_test_page.dart';
import 'package:tajjang/pages/p_login_page.dart';

void main() {
  runApp(const TaJJangApp());
}

class TaJJangApp extends StatelessWidget {
  const TaJJangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/profile',
      getPages: [
        GetPage(name: '/home', page: () => const HomePage(), transition: Transition.downToUp),
        GetPage(name: '/profile', page: () => const ProfilePage(), transition: Transition.downToUp),
        GetPage(name: '/typing_test_launch', page: () => const TypingTestLaunchPage(), transition: Transition.downToUp),
        GetPage(name: '/login', page: () => const LoginPage(), transition: Transition.downToUp),
        GetPage(name: '/word_typing_test', page: () => const WordTypingTestPage(), transition: Transition.downToUp),
        GetPage(name: '/profile_settings', page: () => const ProfileSettingsPage(), transition: Transition.downToUp),
        GetPage(name: '/settings', page: () => const SettingsPage(), transition: Transition.downToUp),
      ],
      theme: ThemeData(
        fontFamily: '나눔고딕',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          bodyMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          bodySmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
