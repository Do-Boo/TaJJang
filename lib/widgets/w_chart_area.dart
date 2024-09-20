import 'package:flutter/material.dart';
import 'package:tajjang/widgets/w_pie_chart_painter.dart';

class ChartArea extends StatelessWidget {
  const ChartArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF4AA9DE),
            ),
            child: CustomPaint(
              painter: PieChartPainter(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Speed 창조력', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildProgressBar(0.7),
                const SizedBox(height: 4),
                _buildProgressBar(0.8),
                const SizedBox(height: 4),
                _buildProgressBar(0.5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double value) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: FractionallySizedBox(
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFB284),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
