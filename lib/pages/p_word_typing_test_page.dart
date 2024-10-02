import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajjang/widgets/w_progressbar.dart';
import 'package:tajjang/pages/p_setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

class WordTypingTestPage extends StatefulWidget {
  const WordTypingTestPage({super.key});

  @override
  _WordTypingTestPageState createState() => _WordTypingTestPageState();
}

class _WordTypingTestPageState extends State<WordTypingTestPage> {
  late List<String> _words;
  late ValueNotifier<String> _inputTextNotifier;
  var correctWords = 0;
  var _currentWordIndex = 0;
  final TextEditingController _textController = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  bool _isStarted = false;
  var _totalErrorWords = 0;
  var _totalCorrectWords = 0;
  int _totalTypedCharacters = 0;
  int _correctCharacters = 0;
  final List<double> _wordSpeeds = [];
  final Stopwatch _wordStopwatch = Stopwatch();
  double _currentWordSpeed = 0;
  bool _isCurrentWordStarted = false;
  bool _isNewWord = true;

  int _wordCount = 20;
  String _language = '영어';
  int _targetSpeed = 200;
  String _mode = '단어'; // '단어' 또는 '문장'

  static final List<String> _koreanSentences = [
    '나는 오늘 행복합니다',
    '꿈을 향해 달려갑니다',
    '세상은 아름답습니다',
    '노력은 배신하지 않습니다',
    '시간은 금과 같습니다',
    '건강이 최고의 재산입니다',
    '사랑은 모든 것을 이깁니다',
    '지식은 힘입니다',
    '웃음은 최고의 약입니다',
    '친구는 제2의 자신입니다',
    '인생은 도전의 연속입니다',
    '변화는 기회를 만듭니다',
    '실패는 성공의 어머니입니다',
    '행복은 선택입니다',
    '오늘을 즐기세요',
    '긍정적인 마음이 중요합니다',
    '꾸준함이 성공의 비결입니다',
    '작은 것에 감사하세요',
    '배움에는 끝이 없습니다',
    '함께하면 더 강해집니다',
  ];

  static String _generateRandomWord(String language, String mode) {
    if (mode == '단어') {
      if (language == '영어') {
        const letters = 'abcdefghijklmnopqrstuvwxyz';
        final random = Random();
        return String.fromCharCodes(Iterable.generate(5, (_) => letters.codeUnitAt(random.nextInt(letters.length))));
      } else {
        const syllables = '가나다라마바사아자차카타파하거너더러머버서어저처커터퍼허고노도로모보소오조초코토포호구누두루무부수우주추쿠투푸후';
        final random = Random();
        return String.fromCharCodes(Iterable.generate(2, (_) => syllables.codeUnitAt(random.nextInt(syllables.length))));
      }
    } else {
      if (language == '영어') {
        // 영어 문장 목록을 추가하고 여기서 랜덤으로 선택
        return "This is an English sentence.";
      } else {
        return _koreanSentences[Random().nextInt(_koreanSentences.length)];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _inputTextNotifier = ValueNotifier<String>('');
    _textController.addListener(_updateInputText);
    _loadSettings().then((_) {
      _resetTest();
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mode = prefs.getString('mode') ?? '단어';
      _wordCount = prefs.getInt('wordCount') ?? 20;
      _language = prefs.getString('language') ?? '영어';
      _targetSpeed = prefs.getInt('targetSpeed') ?? 200;
    });
  }

  void _showSettingsPage() async {
    await Get.to(() => SettingsPage(
          onModeChanged: (String newMode) {
            setState(() {
              _mode = newMode;
              _resetTest();
            });
          },
          onWordCountChanged: (int newWordCount) {
            setState(() {
              _wordCount = newWordCount;
              _resetTest();
            });
          },
          onLanguageChanged: (String newLanguage) {
            setState(() {
              _language = newLanguage;
              _resetTest();
            });
          },
          onTargetSpeedChanged: (int newTargetSpeed) {
            setState(() {
              _targetSpeed = newTargetSpeed;
            });
          },
        ));
    _loadSettings();
  }

  @override
  void dispose() {
    _textController.removeListener(_updateInputText);
    _inputTextNotifier.dispose();
    _textController.dispose();
    _stopwatch.stop();
    _wordStopwatch.stop();
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

    if (_isNewWord && value.isNotEmpty) {
      _isNewWord = false;
      _isCurrentWordStarted = true;
      _wordStopwatch.reset();
      _wordStopwatch.start();
    }

    _totalTypedCharacters = value.length;
    _correctCharacters = 0;

    for (int i = 0; i < value.length && i < currentWord.length; i++) {
      if (value[i] == currentWord[i]) {
        _correctCharacters++;
      }
    }

    if (_isCurrentWordStarted) {
      _currentWordSpeed = (value.length * 60) / (_wordStopwatch.elapsedMilliseconds / 1000);
    }

    setState(() {}); // 상태 업데이트를 위해 추가

    // 문장 모드일 때는 문장 길이만큼 입력되면 다음으로 넘어가도록 수정
    if (_mode == '문장') {
      if (value.length >= currentWord.length) {
        _moveToNextWord(value);
      }
    } else {
      // 단어 모드일 때는 기존 로직 유지
      if (value.length >= currentWord.length || value.endsWith(' ')) {
        _moveToNextWord(value);
      }
    }
  }

  void _moveToNextWord(String value) {
    if (value.trim() == _words[_currentWordIndex]) {
      _totalCorrectWords++;
      _wordSpeeds.add(_currentWordSpeed);
    } else {
      _totalErrorWords++;
    }
    _textController.clear();
    _isCurrentWordStarted = false;
    _isNewWord = true;
    setState(() {
      _currentWordIndex++;
      if (_currentWordIndex >= _words.length) {
        _stopwatch.stop();
        _wordStopwatch.stop();
        _timer?.cancel();
        _showTestResults();
      }
    });
  }

  void _showTestResults() {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 다이얼로그 바깥을 터치해도 닫히지 않도록 설정
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('테스트 완료', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('정확도: ${(_totalCorrectWords / _words.length * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 20)),
            Text('평균 타이핑 속도: ${_averageTypingSpeed.toStringAsFixed(0)} 타/분', style: const TextStyle(color: Colors.white, fontSize: 20)),
            Text('오류율: ${(_errorRate * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              _resetTest(); // 테스트 재설정
              setState(() {}); // UI 업데이트
            },
            child: const Text('확인', style: TextStyle(color: Color(0xFF4CAF50))),
          ),
        ],
      ),
    );
  }

  double get _averageTypingSpeed {
    if (_wordSpeeds.isEmpty) return 0;
    return _wordSpeeds.reduce((a, b) => a + b) / _wordSpeeds.length;
  }

  double get _errorRate {
    return _totalErrorWords / _words.length;
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text('설정', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: _mode,
                    dropdownColor: const Color(0xFF2C2C2C),
                    items: ['단어', '문장'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _mode = newValue;
                        });
                      }
                    },
                  ),
                  DropdownButton<int>(
                    value: _wordCount,
                    dropdownColor: const Color(0xFF2C2C2C),
                    items: [10, 20, 30, 40, 50].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value ${_mode == '단어' ? '단어' : '문장'}', style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _wordCount = newValue;
                        });
                      }
                    },
                  ),
                  DropdownButton<String>(
                    value: _language,
                    dropdownColor: const Color(0xFF2C2C2C),
                    items: ['영어', '한국어'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _language = newValue;
                        });
                      }
                    },
                  ),
                  Text('목표 타수: $_targetSpeed 타/분', style: const TextStyle(color: Colors.white)),
                  Slider(
                    value: _targetSpeed.toDouble(),
                    min: 100,
                    max: 500,
                    divisions: 40,
                    label: _targetSpeed.round().toString(),
                    activeColor: const Color(0xFF4CAF50),
                    inactiveColor: const Color(0xFF2C2C2C),
                    onChanged: (double newValue) {
                      setState(() {
                        _targetSpeed = newValue.round();
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('취소', style: TextStyle(color: Color(0xFF4CAF50))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('확인', style: TextStyle(color: Color(0xFF4CAF50))),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetTest();
                    setState(() {});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _resetTest() {
    setState(() {
      _words = List.generate(_wordCount, (index) => _generateRandomWord(_language, _mode));
      _currentWordIndex = 0;
      _totalErrorWords = 0;
      _totalCorrectWords = 0;
      _totalTypedCharacters = 0;
      _correctCharacters = 0;
      _wordSpeeds.clear();
      _currentWordSpeed = 0;
      _isCurrentWordStarted = false;
      _isNewWord = true;
      _isStarted = false;
      _stopwatch.reset();
      _wordStopwatch.reset();
      _timer?.cancel();
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          'Typing Test',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _showSettingsPage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentCount('$_currentWordIndex/${_words.length}', _currentWordIndex / _words.length),
            const SizedBox(height: 16),
            if (_currentWordIndex < _words.length) _buildCurrentWord(_words[_currentWordIndex]),
            const SizedBox(height: 16),
            _buildProgressBar('속도', _currentWordSpeed / 300, showSpeed: true),
            const SizedBox(height: 8),
            _buildProgressBar('오류율', _errorRate),
            const SizedBox(height: 16),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String title, double progress, {bool showSpeed = false}) {
    Color progressColor = const Color(0xFF4CAF50);
    String displayText;
    double displayProgress;

    if (title == 'Error Rate' || title == '오류율') {
      progressColor = const Color(0xFFE57373);
      displayText = '${(progress * 100).toStringAsFixed(1)}%';
      displayProgress = progress;
    } else {
      if (showSpeed) {
        double speed = _currentWordSpeed;
        displayText = '${speed.toStringAsFixed(0)} 타/분';
        displayProgress = (speed / _targetSpeed).clamp(0.0, 1.0); // _targetSpeed를 최대값으로 사용
      } else {
        displayText = '${(progress * 100).toStringAsFixed(1)}%';
        displayProgress = progress;
      }
    }

    return ProgressBar(
      title: title,
      progress: displayProgress,
      progressColor: progressColor,
      displayText: displayText,
      backgroundColor: const Color(0xFF2C2C2C),
      textColor: Colors.white,
    );
  }

  Widget _buildCurrentCount(String title, double progress) {
    return ProgressBar(
      title: title,
      progress: progress,
      progressColor: const Color(0xFF4CAF50),
      displayText: '$_currentWordIndex/${_words.length}',
      backgroundColor: const Color(0xFF2C2C2C),
      textColor: Colors.white,
    );
  }

  Widget _buildCurrentWord(String word) {
    return ValueListenableBuilder<String>(
      valueListenable: _inputTextNotifier,
      builder: (context, inputText, child) {
        List<TextSpan> textSpans = [];

        for (int i = 0; i < word.length; i++) {
          Color color = Colors.white;
          TextDecoration decoration = TextDecoration.none;

          if (i < inputText.length) {
            if (word[i] != inputText[i]) {
              color = Colors.red;
              decoration = TextDecoration.underline;
            } else {
              color = Colors.green;
            }
          }

          textSpans.add(TextSpan(
            text: word[i],
            style: TextStyle(
              color: color,
              fontSize: 36,
              decoration: decoration,
            ),
          ));
        }

        return Center(
          child: RichText(
            text: TextSpan(children: textSpans),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        onChanged: _onTextChanged,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: 'Type here',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
        ),
        cursorColor: const Color(0xFF4CAF50),
      ),
    );
  }
}
