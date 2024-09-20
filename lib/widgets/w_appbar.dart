import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.arrow_back, color: Color(0xFF4AA9DE)),
          Text('Tajang', style: TextStyle(color: Color(0xFF4AA9DE), fontSize: 24)),
          Icon(Icons.menu, color: Color(0xFF4AA9DE)),
        ],
      ),
    );
  }
}
