import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tajjang/widgets/w_button.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6EE),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: false, // 스크롤 시에도 AppBar 고정
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.transparent, // 투명한 배경색
              ),
            ),
            leading: IconButton(
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, color: Colors.black, size: 32),
              onPressed: () => Get.toNamed('/login'),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xFFF7FAFA)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfile(),
                      _buildQuest('Quest 1: Reach for the stars', 'Type 50 words per minute for 3 minutes'),
                      _buildQuest('Quest 2: Speed of Light', 'Type 100 words per minute for 2 minutes'),
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

  Widget _buildProfile() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F6EE),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: NetworkImage("https://via.placeholder.com/128x128"),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(64),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'NickName',
            style: TextStyle(
              color: Color(0xFF141C23),
              fontSize: 22,
            ),
          ),
          const Text(
            'Status message',
            style: TextStyle(
              color: Color(0xFF3F5472),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuest(String title, String description) {
    return Button(
      padding: EdgeInsets.zero,
      onPressed: () => Get.toNamed('/typing_test_launch'),
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 304,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 201,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/358x201"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF141C23),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF3F5472),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
