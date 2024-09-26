import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String title;
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final String displayText;

  const ProgressBar({
    super.key,
    required this.title,
    required this.progress,
    this.backgroundColor = const Color(0xFFFDFDE2),
    this.progressColor = const Color(0xFFB4E9DC),
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 컨테이너
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffD1CAB7), width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFF5), // 배경색을 약간 더 밝게 조정
                Color(0xFFFAE5D3), // 배경색을 약간 더 밝게 조정
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        // 진행 상태 컨테이너
        Positioned(
          top: 2,
          left: 2,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            child: Container(
              width: progress == 0 ? 0 : (MediaQuery.of(context).size.width - 40) * progress,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    progressColor.withOpacity(0.7),
                    progressColor,
                  ],
                ),
              ),
            ),
          ),
        ),
        // 텍스트 레이어
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF141C23),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  displayText,
                  style: const TextStyle(
                    color: Color(0xFF141C23),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
