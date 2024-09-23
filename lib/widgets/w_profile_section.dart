import 'package:flutter/material.dart';
import 'package:tajjang/widgets/w_button1.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
          const SizedBox(width: 16),
          const Expanded(
            child: Text('Speed Test', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Button1(
            text: 'Friend Challenge',
            onPressed: () => print('Friend Challenge pressed'),
            backgroundColor: const Color(0xFFFFB284),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
