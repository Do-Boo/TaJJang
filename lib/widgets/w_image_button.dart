import 'package:flutter/material.dart';

class AnimatedImageButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const AnimatedImageButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  _AnimatedImageButtonState createState() => _AnimatedImageButtonState();
}

class _AnimatedImageButtonState extends State<AnimatedImageButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onPressed,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              boxShadow: _isHovered ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
            ),
            child: Image.asset(
              widget.imagePath,
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}
