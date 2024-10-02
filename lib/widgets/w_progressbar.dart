import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String title;
  final double progress;
  final Color progressColor;
  final String displayText;
  final Color backgroundColor;
  final Color textColor;

  const ProgressBar({
    super.key,
    required this.title,
    required this.progress,
    this.progressColor = const Color(0xFF4CAF50),
    required this.displayText,
    this.backgroundColor = const Color(0xFF2C2C2C),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 18, // 타이틀 텍스트 크기 증가
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              displayText,
              style: TextStyle(
                color: textColor,
                fontSize: 18, // 숫자 텍스트 크기 증가
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 12, // 프로그레스 바 높이 증가
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 12, // 프로그레스 바 높이 증가
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
