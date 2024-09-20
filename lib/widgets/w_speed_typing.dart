import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';

class SpeedTypingPractice extends StatefulWidget {
  const SpeedTypingPractice({super.key});

  @override
  _SpeedTypingPracticeState createState() => _SpeedTypingPracticeState();
}

class _SpeedTypingPracticeState extends State<SpeedTypingPractice> with SingleTickerProviderStateMixin {
  final List<String> _sentences = [
    "The quick brown fox jumps over the lazy dog.",
    "Pack my box with five dozen liquor jugs.",
    "How vexingly quick daft zebras jump!",
    "Sphinx of black quartz, judge my vow.",
    "Two driven jocks help fax my big quiz.",
    "The five boxing wizards jump quickly.",
    "Bright vixens jump; dozy fowl quack.",
    "Five quacking Zephyrs jolt my wax bed.",
    "The jay, pig, fox, zebra, and my wolves quack!",
    "Cozy lummox gives smart squid who asks for job pen.",
    "The quick onyx goblin jumps over the lazy dwarf.",
    "Jackdaws love my big sphinx of quartz.",
    "The quick brown fox jumps over the lazy dog.",
    "Pack my box with five dozen liquor jugs.",
    "How vexingly quick daft zebras jump!",
    "Sphinx of black quartz, judge my vow.",
    "Two driven jocks help fax my big quiz.",
    "The five boxing wizards jump quickly.",
    "Bright vixens jump; dozy fowl quack.",
    "Five quacking Zephyrs jolt my wax bed."
  ];

  late String _currentSentence;
  late TextEditingController _controller;
  int _currentIndex = 0;
  int _correctChars = 0;
  int _totalChars = 0;
  int _typingSpeed = 0; // 분당 타자 수
  double _accuracy = 100.0;
  DateTime? _startTime;
  Timer? _timer;
  late AnimationController _animationController;
  bool _hasStarted = false;
  bool _isFinished = false;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _currentSentence = _sentences[_currentIndex];
    _controller = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_hasStarted && !_isFinished) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime!);
          _updateTypingSpeed();
        });
      }
    });
  }

  void _updateTypingSpeed() {
    final minutes = _elapsedTime.inMilliseconds / 60000;
    if (minutes > 0) {
      _typingSpeed = (_totalChars / minutes).round();
    }
  }

  void _checkInput(String value) {
    setState(() {
      if (!_hasStarted && value.isNotEmpty) {
        _hasStarted = true;
        _startTimer();
      }

      _correctChars = 0;
      _totalChars = value.length;

      for (int i = 0; i < value.length && i < _currentSentence.length; i++) {
        if (value[i] == _currentSentence[i]) {
          _correctChars++;
        }
      }

      _accuracy = _totalChars > 0 ? (_correctChars / _totalChars) * 100 : 100.0;
      _updateTypingSpeed();
      _animationController.forward(from: 0);

      if (value.length > _currentSentence.length) {
        _nextSentence();
      }
    });
  }

  void _nextSentence() {
    if (_currentIndex < 19) {
      // 20번째 문장까지만 진행
      setState(() {
        _currentIndex++;
        _currentSentence = _sentences[_currentIndex];
        _controller.clear();
        _correctChars = 0;
        _totalChars = _currentSentence.length;
        _hasStarted = false;
        _typingSpeed = 0;
        _accuracy = 100.0;
      });
    } else {
      _finishPractice();
    }
  }

  void _finishPractice() {
    setState(() {
      _isFinished = true;
    });
    _timer?.cancel();
    // 여기에 결과 표시 로직을 추가하세요
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Speed Typing Challenge (${_currentIndex + 1}/20)",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4AA9DE)),
          ),
          const SizedBox(height: 10),
          Text(
            "Time: ${_formatDuration(_elapsedTime)}",
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: RichText(
              text: TextSpan(
                style: commonTextStyle.copyWith(color: Colors.black),
                children: _buildTextSpans(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            onChanged: _checkInput,
            onSubmitted: (_) => _nextSentence(),
            style: commonTextStyle,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hintText: "Type here...",
              hintStyle: commonTextStyle.copyWith(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 20),
          _buildAnimatedGraph("Typing Speed", _typingSpeed.toDouble(), 300, const Color(0xFF4AA9DE)),
          const SizedBox(height: 10),
          _buildAnimatedGraph("Accuracy", _accuracy, 100, const Color(0xFFFFB284)),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans() {
    List<TextSpan> spans = [];
    for (int i = 0; i < _currentSentence.length; i++) {
      if (i < _controller.text.length) {
        if (_currentSentence[i] == _controller.text[i]) {
          spans.add(TextSpan(text: _currentSentence[i], style: const TextStyle(color: Colors.green)));
        } else {
          spans.add(TextSpan(text: _currentSentence[i], style: const TextStyle(color: Colors.red, decoration: TextDecoration.underline)));
        }
      } else {
        spans.add(TextSpan(text: _currentSentence[i]));
      }
    }
    return spans;
  }

  Widget _buildAnimatedGraph(String title, double value, double maxGraphValue, Color color) {
    final currentValue = value.clamp(0.0, double.infinity);
    final graphValue = value.clamp(0.0, maxGraphValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: graphValue / maxGraphValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: value, end: currentValue),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Text(
                    title == "Typing Speed" ? '${value.round()}' : '${value.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

// 공통 텍스트 스타일 정의
const TextStyle commonTextStyle = TextStyle(
  fontSize: 18,
  fontFamily: 'YourFontFamily',
  letterSpacing: 0, // 자간 명시적 설정
  height: 1.2, // 행간 설정
);
