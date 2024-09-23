import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tajjang/widgets/w_button.dart';

class TypingTestLaunchPage extends StatefulWidget {
  const TypingTestLaunchPage({super.key});

  @override
  _TypingTestLaunchPageState createState() => _TypingTestLaunchPageState();
}

class _TypingTestLaunchPageState extends State<TypingTestLaunchPage> {
  int _selectedSentenceCount = 5; // 초기값을 5로 설정
  final FixedExtentScrollController _scrollController = FixedExtentScrollController(initialItem: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFA),
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
                      _buildTitle(),
                      _buildSentenceSelector(),
                      _buildStartButton(),
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

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: const Text(
        'Select the number of sentences to type:',
        style: TextStyle(
          color: Color(0xFF141C23),
          fontSize: 22,
          fontFamily: 'Be Vietnam Pro',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSentenceSelector() {
    return SizedBox(
      height: 150,
      child: CupertinoPicker(
        scrollController: _scrollController,
        itemExtent: 44,
        backgroundColor: Colors.transparent,
        magnification: 1.2, // 자석 효과를 더 강하게 설정
        useMagnifier: true,
        onSelectedItemChanged: (int index) {
          setState(() {
            _selectedSentenceCount = (index + 1) * 5; // 5의 배수로 설정
          });
        },
        children: List<Widget>.generate(6, (int index) {
          // 5, 10, 15, 20, 25, 30
          int value = (index + 1) * 5;
          return Center(
            child: Text(
              '$value',
              style: TextStyle(
                color: _selectedSentenceCount == value ? const Color(0xFF141C23) : const Color(0xFF93A5C6),
                fontSize: 16,
                fontFamily: 'Be Vietnam Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Button(
        color: const Color(0xFFF4C654),
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        onPressed: () {
          // TODO: Implement start typing functionality
        },
        child: const Text(
          'Start typing',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF141C23),
            fontSize: 16,
            fontFamily: 'Be Vietnam Pro',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
