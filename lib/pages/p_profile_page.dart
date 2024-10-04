import 'package:flutter/material.dart';
import 'package:tajjang/widgets/w_progressbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          '내 프로필',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(),
              const SizedBox(height: 24),
              _buildOverallStats(),
              const SizedBox(height: 24),
              _buildDetailedStats(),
              const SizedBox(height: 24),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return const Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFF4CAF50),
          child: Text(
            'JD',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '홍길동',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '타자 마스터 레벨 5',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverallStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '전체 통계',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('총 연습 시간', '24시간'),
              _buildStatItem('평균 속도', '180 타/분'),
              _buildStatItem('평균 정확도', '95%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF4CAF50),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats() {
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
            '상세 통계',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ProgressBar(
            title: '최고 속도',
            progress: 0.9,
            progressColor: Color(0xFF4CAF50),
            displayText: '220 타/분',
            backgroundColor: Color(0xFF2C2C2C),
            textColor: Colors.white,
          ),
          SizedBox(height: 8),
          ProgressBar(
            title: '최고 정확도',
            progress: 0.98,
            progressColor: Color(0xFF4CAF50),
            displayText: '98%',
            backgroundColor: Color(0xFF2C2C2C),
            textColor: Colors.white,
          ),
          SizedBox(height: 8),
          ProgressBar(
            title: '연속 학습일',
            progress: 0.7,
            progressColor: Color(0xFF4CAF50),
            displayText: '7일',
            backgroundColor: Color(0xFF2C2C2C),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '최근 활동',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem('단어 연습', '200 타/분, 97% 정확도', '1시간 전'),
          _buildActivityItem('문장 연습', '180 타/분, 95% 정확도', '어제'),
          _buildActivityItem('긴 글 연습', '170 타/분, 93% 정확도', '2일 전'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String stats, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                stats,
                style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 14),
              ),
            ],
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
