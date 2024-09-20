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

  final List<String> _koreanSentences = [
    "빠른 갈색 여우가 게으른 개를 뛰어넘습니다.",
    "모든 국민은 인간으로서의 존엄과 가치를 가집니다.",
    "세종대왕은 한글을 창제한 조선의 제4대 왕입니다.",
    "우리나라의 국화는 무궁화입니다.",
    "독도는 우리나라 동쪽 끝에 있는 아름다운 섬입니다.",
    "한강은 서울을 가로지르는 큰 강입니다.",
    "김치는 한국의 대표적인 발효 음식입니다.",
    "태권도는 한국의 전통 무술입니다.",
    "제주도는 한국의 가장 큰 섬입니다.",
    "백두산은 한반도의 최고봉입니다.",
    "불고기는 한국의 유명한 고기 요리입니다.",
    "한복은 한국의 전통 의상입니다.",
    "판소리는 한국의 전통 음악입니다.",
    "남대문은 서울의 상징적인 건축물입니다.",
    "bibimbap은 한국의 대표적인 비빔 요리입니다.",
    "소나무는 우리나라의 대표적인 나무입니다.",
    "한옥은 한국의 전통 가옥 양식입니다.",
    "청와대는 대한민국 대통령의 집무실입니다.",
    "광화문은 경복궁의 정문입니다.",
    "남산타워는 서울의 랜드마크입니다.",
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
  bool _practiceStarted = false;
  bool _isFinished = false;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _currentSentence = _koreanSentences[_currentIndex];
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

  void _startPractice() {
    if (!_practiceStarted) {
      _practiceStarted = true;
      _startTime = DateTime.now();
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_practiceStarted && !_isFinished) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime!);
          _updateTypingSpeed();
        });
      }
    });
  }

  void _updateTypingSpeed() {
    if (_startTime != null) {
      final minutes = _elapsedTime.inMilliseconds / 60000;
      if (minutes > 0) {
        setState(() {
          if (_totalChars > 0) {
            _typingSpeed = (_totalChars / minutes).round();
          } else {
            _typingSpeed = 0; // 새 문장의 첫 글자가 입력되기 전에는 0으로 설정
          }
        });
      }
    }
  }

  void _checkInput(String value) {
    if (!_practiceStarted) {
      _startPractice();
    }

    setState(() {
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

      if (value == _currentSentence) {
        _nextSentence();
      }
    });
  }

  void _nextSentence() {
    if (_currentIndex < 19) {
      setState(() {
        _currentIndex++;
        _currentSentence = _koreanSentences[_currentIndex];
        _controller.clear();
        _correctChars = 0;
        _totalChars = 0;
        _accuracy = 100.0;
      });
    } else {
      _finishPractice();
    }
  }

  void _finishPractice() {
    setState(() {
      _isFinished = true;
      _practiceStarted = false;
    });
    _timer?.cancel();
    // 여기에 결과 표시 로직을 추가하세요
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // 전체 패딩을 24에서 20으로 줄임
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4AA9DE).withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Speed Typing Challenge",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4AA9DE)), // 폰트 크기를 22에서 20으로 줄임
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // 패딩을 줄임
                decoration: BoxDecoration(
                  color: const Color(0xFF4AA9DE),
                  borderRadius: BorderRadius.circular(12), // 모서리 반경을 15에서 12로 줄임
                ),
                child: Text(
                  "${_currentIndex + 1}/20",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // 폰트 크기를 16에서 14로 줄임
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // 16에서 12로 줄임
          Text(
            "Time: ${_formatDuration(_elapsedTime)}",
            style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500), // 폰트 크기를 18에서 16으로 줄임
          ),
          const SizedBox(height: 16), // 24에서 16으로 줄임
          Container(
            padding: const EdgeInsets.all(12), // 16에서 12로 줄임
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10), // 12에서 10으로 줄임
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: RichText(
              text: TextSpan(
                style: commonTextStyle.copyWith(color: Colors.black),
                children: _buildTextSpans(),
              ),
            ),
          ),
          const SizedBox(height: 16), // 24에서 16으로 줄임
          TextField(
            controller: _controller,
            onChanged: _checkInput,
            onSubmitted: (_) => _nextSentence(),
            style: commonTextStyle,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), // 패딩을 줄임
              hintText: "Type here...",
              hintStyle: commonTextStyle.copyWith(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // 12에서 10으로 줄임
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // 12에서 10으로 줄임
                borderSide: const BorderSide(color: Color(0xFF4AA9DE), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16), // 24에서 16으로 줄임
          _buildAnimatedGraph("Typing Speed", _typingSpeed.toDouble(), 300, const Color(0xFF4AA9DE)),
          const SizedBox(height: 12), // 16에서 12로 줄임
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
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)), // 폰트 크기를 16에서 14로 줄임
        const SizedBox(height: 6), // 8에서 6으로 줄임
        Stack(
          children: [
            Container(
              height: 20, // 24에서 20으로 줄임
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10), // 12에서 10으로 줄임
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 20, // 24에서 20으로 줄임
              width: (graphValue / maxGraphValue) * (MediaQuery.of(context).size.width - 40), // 48에서 40으로 줄임
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10), // 12에서 10으로 줄임
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0), // 12에서 8로 줄임
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: value, end: currentValue),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Text(
                        title == "Typing Speed" ? '${value.round()} WPM' : '${value.toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), // 폰트 크기를 14에서 12로 줄임
                      );
                    },
                  ),
                ),
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
