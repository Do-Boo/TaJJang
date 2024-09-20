import 'package:flutter/material.dart';
import 'package:tajjang/widgets/w_appbar.dart';
import 'package:tajjang/widgets/w_chart_area.dart';
import 'package:tajjang/widgets/w_friend_challenge_button.dart';
import 'package:tajjang/widgets/w_profile_section.dart';
import 'package:tajjang/widgets/w_tab_menu.dart';
import 'package:tajjang/widgets/w_virtual_keyboard.dart';

class TaJJangHomePage extends StatelessWidget {
  const TaJJangHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const IntrinsicHeight(
                  child: Column(
                    children: [
                      CustomAppBar(),
                      TabMenu(),
                      Expanded(child: VirtualKeyboard()),
                      FriendChallengeButton(),
                      ProfileSection(),
                      ChartArea(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
