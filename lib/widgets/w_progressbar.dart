import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String title;
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  const ProgressBar({
    super.key,
    required this.title,
    required this.progress,
    this.backgroundColor = const Color(0xFFD3DBE8),
    this.progressColor = const Color(0xFFF4C654),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 8,
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        Positioned(
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * progress - 32, // 32는 좌우 패딩 값
            height: 8,
            decoration: ShapeDecoration(
              color: progressColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }
}
