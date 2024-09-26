import 'package:flutter/material.dart';

class CustomImageButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Size size;

  const CustomImageButton({super.key, required this.child, required this.onPressed, required this.size});

  @override
  _CustomImageButtonState createState() => _CustomImageButtonState();
}

class _CustomImageButtonState extends State<CustomImageButton> {
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
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/button.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: widget.child,
                ),
              );
            }),
      ),
    );
  }
}
