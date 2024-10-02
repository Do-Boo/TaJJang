import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3D Frame Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Cube3DDemo(),
    );
  }
}

class Cube3DDemo extends StatefulWidget {
  const Cube3DDemo({super.key});

  @override
  _Cube3DDemoState createState() => _Cube3DDemoState();
}

class _Cube3DDemoState extends State<Cube3DDemo> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _angle += 0.02;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D Cube Frame Demo')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: CubePainter(_angle),
          ),
        ),
      ),
    );
  }
}

class CubePainter extends CustomPainter {
  final double angle;

  CubePainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final side = size.width * 0.5;

    final vertices = [
      Vector3(-1, -1, -1),
      Vector3(1, -1, -1),
      Vector3(1, 1, -1),
      Vector3(-1, 1, -1),
      Vector3(-1, -1, 1),
      Vector3(1, -1, 1),
      Vector3(1, 1, 1),
      Vector3(-1, 1, 1),
    ];

    final rotationMatrix = Matrix4.rotationY(angle) * Matrix4.rotationX(angle * 0.7);

    final projectedVertices = vertices.map((v) {
      var rotated = rotationMatrix.transform3(v);
      var scaled = Vector3(rotated.x * side, rotated.y * side, rotated.z);
      return Offset(scaled.x + center.dx, scaled.y + center.dy);
    }).toList();

    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw edges
    canvas.drawLine(projectedVertices[0], projectedVertices[1], paint);
    canvas.drawLine(projectedVertices[1], projectedVertices[2], paint);
    canvas.drawLine(projectedVertices[2], projectedVertices[3], paint);
    canvas.drawLine(projectedVertices[3], projectedVertices[0], paint);

    canvas.drawLine(projectedVertices[4], projectedVertices[5], paint);
    canvas.drawLine(projectedVertices[5], projectedVertices[6], paint);
    canvas.drawLine(projectedVertices[6], projectedVertices[7], paint);
    canvas.drawLine(projectedVertices[7], projectedVertices[4], paint);

    canvas.drawLine(projectedVertices[0], projectedVertices[4], paint);
    canvas.drawLine(projectedVertices[1], projectedVertices[5], paint);
    canvas.drawLine(projectedVertices[2], projectedVertices[6], paint);
    canvas.drawLine(projectedVertices[3], projectedVertices[7], paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Vector3 {
  final double x, y, z;
  Vector3(this.x, this.y, this.z);
}

class Matrix4 {
  final List<double> values;

  Matrix4.rotationY(double angle) : values = [cos(angle), 0, sin(angle), 0, 0, 1, 0, 0, -sin(angle), 0, cos(angle), 0, 0, 0, 0, 1];

  Matrix4.rotationX(double angle) : values = [1, 0, 0, 0, 0, cos(angle), -sin(angle), 0, 0, sin(angle), cos(angle), 0, 0, 0, 0, 1];

  Vector3 transform3(Vector3 v) {
    return Vector3(
      values[0] * v.x + values[1] * v.y + values[2] * v.z,
      values[4] * v.x + values[5] * v.y + values[6] * v.z,
      values[8] * v.x + values[9] * v.y + values[10] * v.z,
    );
  }

  Matrix4 operator *(Matrix4 other) {
    var result = List<double>.filled(16, 0);
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        for (var k = 0; k < 4; k++) {
          result[i * 4 + j] += values[i * 4 + k] * other.values[k * 4 + j];
        }
      }
    }
    return Matrix4._fromList(result);
  }

  Matrix4._fromList(this.values);
}
