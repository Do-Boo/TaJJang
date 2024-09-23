import 'package:flutter/material.dart';
import 'package:tajjang/widgets/w_button1.dart';

class FriendChallengeButton extends StatelessWidget {
  const FriendChallengeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
      child: Button1(
        text: 'Friend Challenge',
        onPressed: () => print('Friend Challenge pressed'),
        backgroundColor: const Color(0xFFFFF0E6),
        textColor: const Color(0xFFFFA366),
      ),
    );
  }
}
