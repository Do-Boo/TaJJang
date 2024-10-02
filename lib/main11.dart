import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '자유 지렁이 게임',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int initialLength = 15;
  static const double snakeSegmentSize = 30.0; // 크기를 30으로 증가
  static const double mapSize = 2000.0;

  List<Offset> snakePositions = List.generate(initialLength, (index) => Offset(100.0 + index * snakeSegmentSize, 100.0));
  Offset food = const Offset(200, 200);
  Offset direction = const Offset(1, 0);
  Timer? timer;
  int score = 0;
  Offset? joystickPosition;
  Offset? joystickDelta;
  Offset cameraOffset = Offset.zero;
  Offset targetDirection = const Offset(1, 0);
  static const double turnSpeed = 0.2; // 회전 속도 조절
  double snakeGrowthFactor = 1.0; // 지렁이 크기 성장 요소 추가
  bool isBlinking = false;
  Timer? blinkTimer;

  @override
  void initState() {
    super.initState();
    startGame();
    startBlinkTimer();
  }

  void startGame() {
    const duration = Duration(milliseconds: 20); // 50에서 30으로 줄임
    timer = Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        showGameOverDialog();
      }
    });
  }

  void startBlinkTimer() {
    const blinkDuration = Duration(milliseconds: 200);
    const blinkInterval = Duration(seconds: 3);
    blinkTimer = Timer.periodic(blinkInterval, (timer) {
      setState(() {
        isBlinking = true;
      });
      Future.delayed(blinkDuration, () {
        if (mounted) {
          setState(() {
            isBlinking = false;
          });
        }
      });
    });
  }

  void updateSnake() {
    setState(() {
      direction = _smoothTurn(direction, targetDirection);

      // 성장 요소에 따라 이동 거리 조정
      Offset newPosition = snakePositions.last + direction * (snakeSegmentSize * snakeGrowthFactor / 5);

      // 맵 경계 처리
      newPosition = Offset(
        newPosition.dx % mapSize,
        newPosition.dy % mapSize,
      );

      snakePositions.add(newPosition);

      if ((newPosition - food).distance < snakeSegmentSize * snakeGrowthFactor / 2) {
        score++;
        generateNewFood();
        snakeGrowthFactor += 0.02;
      } else {
        snakePositions.removeAt(0);
      }

      updateCameraPosition();
    });
  }

  Offset _smoothTurn(Offset current, Offset target) {
    double angle = atan2(current.dy, current.dx);
    double targetAngle = atan2(target.dy, target.dx);

    // 각도 차이 계산
    double diff = targetAngle - angle;
    if (diff > pi) diff -= 2 * pi;
    if (diff < -pi) diff += 2 * pi;

    // 부드러운 회전
    angle += diff * turnSpeed;

    return Offset(cos(angle), sin(angle));
  }

  void updateCameraPosition() {
    Offset head = snakePositions.last;
    Size screenSize = MediaQuery.of(context).size;
    cameraOffset = Offset(
      head.dx - screenSize.width / 2,
      head.dy - screenSize.height / 2,
    );
  }

  bool gameOver() {
    if (snakePositions.length <= initialLength) return false;

    Offset head = snakePositions.last;

    // 머리가 자신의 몸통(초기 길이 이후의 부분)과 충돌하는지 검사
    for (int i = 0; i < snakePositions.length - initialLength - 1; i++) {
      if ((snakePositions[i] - head).distance < snakeSegmentSize * 0.5) {
        return true;
      }
    }

    return false;
  }

  void generateNewFood() {
    final random = Random();
    food = Offset(
      random.nextDouble() * mapSize,
      random.nextDouble() * mapSize,
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('게임 오버'),
          content: Text('점수: $score'),
          actions: <Widget>[
            TextButton(
              child: const Text('다시 시'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      snakePositions = List.generate(initialLength, (index) => Offset(100.0 + index * snakeSegmentSize, 100.0));
      direction = const Offset(1, 0);
      score = 0;
      snakeGrowthFactor = 1.0; // 게임 재시작 시 크기 초기화
      generateNewFood();
    });
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자유 지렁이 게임 - 점수: $score'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                joystickPosition = details.localPosition;
                joystickDelta = Offset.zero;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                joystickDelta = details.localPosition - joystickPosition!;
                if (joystickDelta!.distance > 0) {
                  targetDirection = joystickDelta! / joystickDelta!.distance;
                }
              });
            },
            onPanEnd: (details) {
              setState(() {
                joystickPosition = null;
                joystickDelta = null;
              });
            },
            child: Container(
              color: Colors.black,
              child: ClipRect(
                child: Transform.translate(
                  offset: -cameraOffset,
                  child: CustomPaint(
                    painter: GamePainter(snakePositions, food, mapSize, snakeGrowthFactor, isBlinking),
                    size: const Size(mapSize, mapSize),
                  ),
                ),
              ),
            ),
          ),
          if (joystickPosition != null)
            Positioned(
              left: joystickPosition!.dx - 50,
              top: joystickPosition!.dy - 50,
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Transform.translate(
                      offset: joystickDelta ?? Offset.zero,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Opacity(
              opacity: 0.7,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomPaint(
                  painter: MiniMapPainter(snakePositions, food, mapSize),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    blinkTimer?.cancel();
    super.dispose();
  }
}

class GamePainter extends CustomPainter {
  final List<Offset> snakePositions;
  final Offset food;
  final double mapSize;
  final double snakeGrowthFactor;
  final bool isBlinking;
  static const double baseSnakeSegmentSize = 30.0;
  static const double foodSize = 30.0;

  GamePainter(this.snakePositions, this.food, this.mapSize, this.snakeGrowthFactor, this.isBlinking);

  @override
  void paint(Canvas canvas, Size size) {
    // 맵
    final mapPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, mapSize, mapSize), mapPaint);

    // 지렁이 그리기
    final snakeSegmentSize = baseSnakeSegmentSize * snakeGrowthFactor;
    for (var i = 0; i < snakePositions.length; i++) {
      final position = snakePositions[i];
      final segmentPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            i % 5 == 0 ? Colors.yellowAccent.withOpacity(0.8) : Colors.lightGreenAccent.withOpacity(0.8),
            i % 5 == 0 ? Colors.orange.shade800.withOpacity(0.8) : Colors.green.shade800.withOpacity(0.8),
          ],
          stops: const [0.0, 1.0],
          center: Alignment.topLeft,
          radius: 0.8,
        ).createShader(Rect.fromCircle(
          center: position,
          radius: snakeSegmentSize / 2,
        ))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(position, snakeSegmentSize / 2, segmentPaint);

      // 표면 텍스처 추가
      final texturePaint = Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..style = PaintingStyle.fill;

      for (int j = 0; j < 2; j++) {
        final angle = math.Random().nextDouble() * 2 * math.pi;
        final radius = math.Random().nextDouble() * snakeSegmentSize / 2;
        final texturePosition = Offset(
          position.dx + radius * math.cos(angle),
          position.dy + radius * math.sin(angle),
        );
        canvas.drawCircle(texturePosition, snakeSegmentSize / 20, texturePaint);
      }

      // 지렁이 눈 그리기 (머리에만)
      if (i == snakePositions.length - 1) {
        final direction = snakePositions.last - snakePositions[snakePositions.length - 2];
        final normalizedDirection = direction / direction.distance;

        // 눈 위치 조정 (성장 요소 반영)
        final eyeOffset = Offset(
          snakeSegmentSize * 0.5 * normalizedDirection.dx,
          snakeSegmentSize * 0.5 * normalizedDirection.dy,
        );
        final eyeCenter = position + eyeOffset;

        final eyeSize = baseSnakeSegmentSize * snakeGrowthFactor;

        canvas.save();
        canvas.translate(eyeCenter.dx, eyeCenter.dy);
        canvas.rotate(direction.direction);

        // 눈썹 그리기
        final eyebrowPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = eyeSize * 0.05;

        // 오른쪽 눈썹
        canvas.drawArc(
          Rect.fromCircle(
            center: Offset(-eyeSize * 0.3, -eyeSize * 0.3),
            radius: eyeSize * 0.2,
          ),
          pi * -0.8,
          pi * -0.6,
          false,
          eyebrowPaint,
        );

        // 왼쪽 눈썹
        canvas.drawArc(
          Rect.fromCircle(
            center: Offset(-eyeSize * 0.3, eyeSize * 0.3),
            radius: eyeSize * 0.2,
          ),
          pi * 0.8,
          pi * 0.6,
          false,
          eyebrowPaint,
        );

        if (!isBlinking) {
          // 열린 눈 그리기
          final eyePaint = Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

          final topCircle = Path()..addOval(Rect.fromCircle(center: Offset(0, -eyeSize * 0.3), radius: eyeSize * 0.3));
          final bottomCircle = Path()..addOval(Rect.fromCircle(center: Offset(0, eyeSize * 0.3), radius: eyeSize * 0.3));

          final combinedPath = Path.combine(PathOperation.union, topCircle, bottomCircle);
          canvas.drawPath(combinedPath, eyePaint);

          // 동공 그리기
          final pupilPaint = Paint()
            ..color = Colors.black
            ..style = PaintingStyle.fill;

          canvas.drawCircle(Offset(0, -eyeSize * 0.25), eyeSize * 0.18, pupilPaint);
          canvas.drawCircle(Offset(0, eyeSize * 0.25), eyeSize * 0.18, pupilPaint);

          // 눈 반사광 추가
          final reflectionPaint = Paint()
            ..color = Colors.white.withOpacity(0.7)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(Offset(-eyeSize * 0.12, -eyeSize * 0.37), eyeSize * 0.1, reflectionPaint);
          canvas.drawCircle(Offset(-eyeSize * 0.12, eyeSize * 0.13), eyeSize * 0.1, reflectionPaint);
        } else {
          // 감은 눈 그리기
          final closedEyePaint = Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = eyeSize * 0.05;

          canvas.drawLine(
              Offset(0, -eyeSize * 0.6), // 8자 모양의 최상단
              Offset(0, eyeSize * 0.6), // 8자 모양의 최하단
              closedEyePaint);
        }

        canvas.restore();
      }
    }

    // 음식 그리기
    final foodPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.redAccent, Colors.red.shade900],
        stops: const [0.0, 1.0],
        center: Alignment.topLeft,
        radius: 0.8,
      ).createShader(Rect.fromCircle(
        center: food,
        radius: foodSize / 2,
      ))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(food, foodSize / 2, foodPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MiniMapPainter extends CustomPainter {
  final List<Offset> snakePositions;
  final Offset food;
  final double mapSize;

  MiniMapPainter(this.snakePositions, this.food, this.mapSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // 지렁이 그리기
    paint.color = Colors.green;
    for (var position in snakePositions) {
      canvas.drawCircle(
        Offset(
          (position.dx / mapSize) * size.width,
          (position.dy / mapSize) * size.height,
        ),
        2, // 미니맵에서의 크기를 약간 키움
        paint,
      );
    }

    // 음식 그리기
    paint.color = Colors.red;
    canvas.drawCircle(
      Offset(
        (food.dx / mapSize) * size.width,
        (food.dy / mapSize) * size.height,
      ),
      3, // 미니맵에서의 크기를 약간 키움
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
