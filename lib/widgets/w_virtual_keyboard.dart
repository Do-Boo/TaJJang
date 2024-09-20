import 'package:flutter/material.dart';
import 'dart:math';

class VirtualKeyboard extends StatefulWidget {
  const VirtualKeyboard({super.key});

  @override
  _VirtualKeyboardState createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard> {
  String? pressedKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildKeyboardRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
          const SizedBox(height: 8),
          _buildKeyboardRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L']),
          const SizedBox(height: 8),
          _buildLastRow(),
          const SizedBox(height: 8),
          _buildSpaceRow(),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keys
            .map((key) => AspectRatio(
                  aspectRatio: 3 / 4,
                  child: _buildAnimatedKey(key),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLastRow() {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),
          ...['Z', 'X', 'C', 'V', 'B', 'N', 'M'].map((key) => AspectRatio(
                aspectRatio: 3 / 4,
                child: _buildAnimatedKey(key),
              )),
          Expanded(child: _buildAnimatedKey('⌫', isSpecial: true)),
        ],
      ),
    );
  }

  Widget _buildSpaceRow() {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildAnimatedKey('Shift', isSpecial: true)),
        Expanded(flex: 6, child: _buildAnimatedKey('Space')),
        Expanded(flex: 2, child: _buildAnimatedKey('Enter', isSpecial: true)),
      ],
    );
  }

  Widget _buildAnimatedKey(String text, {bool isSpecial = false}) {
    bool isPressed = pressedKey == text;
    final color = isSpecial ? Colors.grey[300]! : _getRandomPastelColor();

    return GestureDetector(
      onTapDown: (_) => setState(() => pressedKey = text),
      onTapUp: (_) => setState(() => pressedKey = null),
      onTapCancel: () => setState(() => pressedKey = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.all(isPressed ? 4 : 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: isPressed ? 1 : 2,
              blurRadius: isPressed ? 3 : 5,
              offset: isPressed ? const Offset(0, 1) : const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSpecial ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Color _getRandomPastelColor() {
    final random = Random();
    return Color.fromRGBO(
      200 + random.nextInt(55),
      200 + random.nextInt(55),
      200 + random.nextInt(55),
      1,
    );
  }
}
