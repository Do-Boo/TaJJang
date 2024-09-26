import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tajjang/widgets/w_button.dart';
import 'package:tajjang/widgets/w_custom_switch.dart';
import 'package:tajjang/widgets/w_image_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.transparent,
              ),
            ),
            leading: IconButton(
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, color: Colors.black, size: 32),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFF141C23),
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSettingsItem('Account', HugeIcons.strokeRoundedUserCircle, onTap: () {
                  // TODO: Implement account settings action
                }),
                _buildSettingsItem('Learning Goal', HugeIcons.strokeRoundedBounceRight, onTap: () {
                  // TODO: Implement learning goal settings action
                }),
                _buildSettingsItem('Theme', HugeIcons.strokeRoundedMoon02, value: 'Light', onTap: () {
                  // TODO: Implement theme settings action
                }),
                _buildSettingsItem('Language', HugeIcons.strokeRoundedGlobe02, value: 'English', onTap: () {
                  // TODO: Implement language settings action
                }),
                _buildSoundSection(),
                _buildBackToGameButton(),
                AnimatedImageButton(
                  imagePath: 'assets/your_image.png',
                  onPressed: () {
                    print('Button pressed!');
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, {String? value, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildIconContainer(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF141C23),
                  fontSize: 16,
                  fontFamily: 'Be Vietnam Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (value != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF141C23),
                    fontSize: 14,
                    fontFamily: 'Be Vietnam Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, size: 24, color: Color(0xFF141C23)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItemWithSwitch(String title, IconData icon) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildIconContainer(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF141C23),
                fontSize: 16,
                fontFamily: 'Be Vietnam Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Switch(
            value: false, // TODO: Implement switch state
            onChanged: (bool value) {
              // TODO: Implement switch functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSoundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 20, bottom: 12),
          child: Text(
            'Sound',
            style: TextStyle(
              color: Color(0xFF141C23),
              fontSize: 22,
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _buildSoundItem('Music', HugeIcons.strokeRoundedMusicNote03),
        _buildSoundItem('Sound Effects', HugeIcons.strokeRoundedVolumeHigh),
      ],
    );
  }

  Widget _buildSoundItem(String title, IconData icon) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildIconContainer(icon, size: 48),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
              const Text(
                'On',
                style: TextStyle(
                  color: Color(0xFF3F5472),
                  fontSize: 14,
                  fontFamily: 'Be Vietnam Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          CustomSwitch(
            value: true, // TODO: Implement switch state
            onChanged: (bool value) {
              // TODO: Implement switch functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackToGameButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Button(
        color: const Color(0xFFE2E8F2),
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.symmetric(vertical: 16),
        onPressed: () {
          // TODO: Implement back to game functionality
        },
        child: const Text(
          'Back to Game',
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

  Widget _buildIconContainer(IconData icon, {double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: HugeIcon(icon: icon, size: 24, color: const Color(0xFF141C23)),
      ),
    );
  }
}
