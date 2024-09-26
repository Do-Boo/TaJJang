import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tajjang/widgets/w_progressbar.dart';
import 'dart:async';
import 'dart:math';

class WordTypingTestPage extends StatefulWidget {
  const WordTypingTestPage({super.key});

  @override
  _WordTypingTestPageState createState() => _WordTypingTestPageState();
}

class _WordTypingTestPageState extends State<WordTypingTestPage> {
  final List<String> _words = List.generate(20, (index) => _generateRandomWord());
  var correctWords = 0;
  var _currentWordIndex = 0;
  final TextEditingController _textController = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  bool _isStarted = false;
  late ValueNotifier<String> _inputTextNotifier;
  var _totalTypedCharacters = 0;
  var _totalErrorWords = 0;
  var _correctCharacters = 0;

  static String _generateRandomWord() {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(5, (_) => letters.codeUnitAt(random.nextInt(letters.length))));
  }

  @override
  void initState() {
    super.initState();
    _inputTextNotifier = ValueNotifier('');
    _textController.addListener(_updateInputText);
  }

  @override
  void dispose() {
    _textController.removeListener(_updateInputText);
    _inputTextNotifier.dispose();
    _textController.dispose();
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  void _updateInputText() {
    _inputTextNotifier.value = _textController.text;
  }

  void _startTimer() {
    if (!_isStarted) {
      _isStarted = true;
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {});
      });
    }
  }

  void _onTextChanged(String value) {
    if (!_isStarted) {
      _startTimer();
    }
    if (_currentWordIndex >= _words.length) {
      return;
    }

    String currentWord = _words[_currentWordIndex];

    _totalTypedCharacters = value.length;
    _correctCharacters = 0;

    for (int i = 0; i < value.length && i < currentWord.length; i++) {
      if (value[i] == currentWord[i]) {
        _correctCharacters++;
      }
    }

    setState(() {}); // 상태 업데이트를 위해 추가

    if (value.length >= currentWord.length || value.endsWith(' ')) {
      if (value.trim() != currentWord) {
        _totalErrorWords++;
      }
      _textController.clear();
      setState(() {
        _currentWordIndex++;
        if (_currentWordIndex >= _words.length) {
          _stopwatch.stop();
          _timer?.cancel();
          _showTestResults();
        }
      });
    }
  }

  void _showTestResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('테스트 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('정확도: ${(correctWords / _words.length * 100).toStringAsFixed(2)}%'),
            Text('타이핑 속도: ${_typingSpeed.toStringAsFixed(2)} CPM'),
            Text('오류율: ${(_errorRate * 100).toStringAsFixed(2)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed('/typing-test-launch');
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  double get _typingSpeed {
    final minutes = _stopwatch.elapsed.inMinutes + (_stopwatch.elapsed.inSeconds / 60);
    return _correctCharacters / (minutes > 0 ? minutes : 1);
  }

  double get _errorRate {
    return _totalErrorWords / _words.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6EE),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.transparent,
              ),
            ),
            leading: IconButton(
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, color: Colors.black, size: 32),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              'Typing Test',
              style: TextStyle(
                color: Color(0xFF141C23),
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  width: double.infinity,
                  height: 375,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCurrentCount('$_currentWordIndex/${_words.length} words', _currentWordIndex / _words.length),
                      if (_currentWordIndex < _words.length) _buildCurrentWord(_words[_currentWordIndex]),
                      _buildProgressBar('Typing Speed', _typingSpeed / 300, showSpeed: true),
                      _buildProgressBar('Error Rate', _errorRate),
                      _buildInputField(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String title, double progress, {bool showSpeed = false}) {
    Color progressColor;
    String displayText;
    double displayProgress;

    if (title == 'Error Rate') {
      progressColor = Color.lerp(const Color(0xFFB4E9DC), Colors.red, progress)!;
      displayText = '${(progress * 100).toStringAsFixed(1)}%';
      displayProgress = progress;
    } else {
      progressColor = const Color(0xFFB4E9DC);
      if (showSpeed) {
        displayText = '${_typingSpeed.toStringAsFixed(0)} CPM';
        displayProgress = _typingSpeed / 300; // 300 CPM을 최대로 가정
      } else {
        displayText = '${(progress * 100).toStringAsFixed(1)}%';
        displayProgress = progress;
      }
    }

    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.all(16),
      child: ProgressBar(
        title: title,
        progress: displayProgress,
        progressColor: progressColor,
        displayText: displayText,
      ),
    );
  }

  Widget _buildCurrentCount(String title, double progress) {
    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.all(16),
      child: ProgressBar(
        title: title,
        progress: progress,
        progressColor: const Color(0xFFB4E9DC),
        displayText: '${(progress * 100).toStringAsFixed(1)}%',
      ),
    );
  }

  Widget _buildCurrentWord(String word) {
    return ValueListenableBuilder<String>(
      valueListenable: _inputTextNotifier,
      builder: (context, inputText, child) {
        List<TextSpan> textSpans = [];

        for (int i = 0; i < word.length; i++) {
          Color color = const Color(0xFF141C23);
          TextDecoration decoration = TextDecoration.none;

          if (i < inputText.length) {
            if (word[i] != inputText[i]) {
              color = Colors.red;
              decoration = TextDecoration.underline;
            }
          }

          textSpans.add(TextSpan(
            text: word[i],
            style: TextStyle(
              color: color,
              fontSize: 42,
              decoration: decoration,
            ),
          ));
        }

        return SizedBox(
          width: double.infinity,
          height: 67,
          child: Center(
            child: RichText(
              text: TextSpan(children: textSpans),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD3DBE8)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: _textController,
                        onChanged: _onTextChanged,
                        decoration: const InputDecoration(
                          hintText: 'Type here',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 117, 138, 168),
                            fontSize: 24,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
