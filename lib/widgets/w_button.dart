import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Color? color;
  final VoidCallback? onPressed;
  final Widget? child;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsets? padding;

  const Button({super.key, this.color, this.border, this.child, this.borderRadius, this.onPressed, this.padding});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
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
    return GestureDetector(
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
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffD1CAB7), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFfdfeee),
                      Color(0xFFF6CFB2),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 5),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3, left: 2, right: 1),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFCEFD1),
                          Color(0xFFFEF1D1),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
