import 'package:flutter/material.dart';

class Button1 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool isExpanded;

  const Button1({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 18,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: fontSize)),
    );

    if (isExpanded) {
      return Expanded(child: Padding(padding: const EdgeInsets.all(2), child: button));
    } else {
      return Padding(padding: const EdgeInsets.all(2), child: button);
    }
  }
}
