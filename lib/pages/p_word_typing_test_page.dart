import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tajjang/widgets/w_progressbar.dart';

class WordTypingTestPage extends StatelessWidget {
  const WordTypingTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
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
              onPressed: () {
                // TODO: Implement settings functionality
              },
            ),
            title: const Text(
              'Typing Test',
              style: TextStyle(
                color: Color(0xFF141C23),
                fontSize: 18,
                fontFamily: 'Be Vietnam Pro',
                fontWeight: FontWeight.w700,
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
                      _buildCurrentCount('15/30 words', 0.5),
                      _buildCurrentWord('apple'),
                      _buildProgressBar('Typing Speed', 0.8),
                      _buildProgressBar('Error Rate', 0.2),
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

  Widget _buildProgressBar(String title, double progress) {
    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF141C23),
              fontSize: 16,
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ProgressBar(title: title, progress: progress),
        ],
      ),
    );
  }

  Widget _buildCurrentCount(String title, double progress) {
    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBar(title: title, progress: progress),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF141C23),
              fontSize: 16,
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWord(String word) {
    return Container(
      width: double.infinity,
      height: 67,
      padding: const EdgeInsets.all(16),
      child: Text(
        word,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF141C23),
          fontSize: 28,
          fontFamily: 'Be Vietnam Pro',
          fontWeight: FontWeight.w700,
        ),
      ),
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
              child: const Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type here',
                          hintStyle: TextStyle(
                            color: Color(0xFF3F5472),
                            fontSize: 16,
                            fontFamily: 'Be Vietnam Pro',
                            fontWeight: FontWeight.w400,
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
