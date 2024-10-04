import 'package:flutter/material.dart';
import 'package:tajjang/widgets/w_progressbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          '타자 마스터',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // TODO: 설정 페이지로 이동
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildRecentPerformance(),
            const SizedBox(height: 24),
            _buildModeSelection(),
            const SizedBox(height: 24),
            _buildQuickStart(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPerformance() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '최근 성과',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ProgressBar(
            title: '평균 속도',
            progress: 0.7,
            progressColor: Color(0xFF4CAF50),
            displayText: '210 타/분',
            backgroundColor: Color(0xFF2C2C2C),
            textColor: Colors.white,
          ),
          SizedBox(height: 8),
          ProgressBar(
            title: '정확도',
            progress: 0.9,
            progressColor: Color(0xFF4CAF50),
            displayText: '95%',
            backgroundColor: Color(0xFF2C2C2C),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '모드 선택',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildModeButton('단어 연습', Icons.short_text),
            _buildModeButton('문장 연습', Icons.subject),
            _buildModeButton('긴 글 연습', Icons.article),
          ],
        ),
      ],
    );
  }

  Widget _buildModeButton(String title, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        // TODO: 해당 모드로 이동
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C2C2C),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50), size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStart() {
    return ElevatedButton(
      onPressed: () {
        // TODO: 빠른 시작 기능 구현
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Center(
        child: Text(
          '빠른 시작',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
