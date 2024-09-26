import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tajjang/widgets/w_button.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

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
            leading: IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowDown01,
                size: 24,
                color: Color(0xFF141C23),
              ),
              onPressed: () {
                // TODO: Implement back functionality
              },
            ),
            title: const Text(
              'Settings',
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
                _buildProfilePicture(),
                _buildChangePhotoButton(),
                _buildInputField('Nickname'),
                _buildInputField('Status message'),
                _buildInputField('Goal Typing Speed'),
                _buildSaveChangesButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: Color(0xFFF8F6EE),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage("https://via.placeholder.com/120x120"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePhotoButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: Button(
          color: const Color(0xFFF4EFDB),
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onPressed: () {
            // TODO: Implement change photo functionality
          },
          child: const Text(
            'Change Photo',
            style: TextStyle(
              color: Color(0xFF21190A),
              fontSize: 14,
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF21190A),
              fontSize: 16,
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            decoration: ShapeDecoration(
              color: const Color(0xFFF7FAFA),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFD4DBE8)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Enter $label',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveChangesButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Button(
        color: const Color(0xFFF9C638),
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.symmetric(vertical: 16),
        onPressed: () {
          // TODO: Implement save changes functionality
        },
        child: const Text(
          'Save Changes',
          style: TextStyle(
            color: Color(0xFF141C24),
            fontSize: 16,
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
