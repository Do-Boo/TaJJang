import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'widgets/w_button1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Color.fromARGB(255, 208, 236, 224), // 밝은 색상
              //     Color(0xFFC1D6CD), // 어두운 색상
              //   ],
              // ),
              // image: DecorationImage(
              //   image: AssetImage("assets/images/background.png"), // 배경 이미지 파일 경로
              //   fit: BoxFit.cover,
              // ),
              ),
          child: Center(
            child: CustomRoundedButton(
              size: const Size(200, 50),
              child: const Text(
                'Click me',
                style: TextStyle(fontFamily: '금은보화', fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRoundedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Size size;

  const CustomRoundedButton({super.key, required this.child, required this.onPressed, required this.size});

  @override
  _CustomRoundedButtonState createState() => _CustomRoundedButtonState();
}

class _CustomRoundedButtonState extends State<CustomRoundedButton> {
  bool _isPressed = false;

  void _setPressed(bool isPressed) {
    if (mounted) {
      setState(() {
        _isPressed = isPressed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 100),
            tween: Tween(begin: 1.0, end: _isPressed ? 0.95 : 1.0),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.size.height * 0.4),
                    border: Border.all(color: const Color(0xff975947), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3, top: 3),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 3, right: 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular((widget.size.height - 3) * 0.4),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE1F6ED), // 밝은 색상
                            Color(0xFFC1D6CD), // 어두운 색상
                          ],
                        ),
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
