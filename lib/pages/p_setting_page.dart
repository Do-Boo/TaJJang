import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tajjang/widgets/w_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final Function(String)? onModeChanged;
  final Function(int)? onWordCountChanged;
  final Function(String)? onLanguageChanged;
  final Function(int)? onTargetSpeedChanged;

  const SettingsPage({
    super.key,
    this.onModeChanged,
    this.onWordCountChanged,
    this.onLanguageChanged,
    this.onTargetSpeedChanged,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _mode;
  late int _wordCount;
  late String _language;
  late int _targetSpeed;
  bool _settingsChanged = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mode = prefs.getString('mode') ?? '단어';
      _wordCount = prefs.getInt('wordCount') ?? 20;
      _language = prefs.getString('language') ?? '영어';
      _targetSpeed = prefs.getInt('targetSpeed') ?? 200;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mode', _mode);
    await prefs.setInt('wordCount', _wordCount);
    await prefs.setString('language', _language);
    await prefs.setInt('targetSpeed', _targetSpeed);
    _settingsChanged = false;
  }

  void _updateSetting(Function() updateFunction) {
    setState(() {
      updateFunction();
      _settingsChanged = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (_settingsChanged) {
      return await _showSaveConfirmationDialog() ?? false;
    }
    return true;
  }

  Future<bool?> _showSaveConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('설정 저장', style: TextStyle(color: Colors.white)),
        content: const Text('변경된 설정을 저장하시겠습니까?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('아니오', style: TextStyle(color: Color(0xFF4CAF50))),
          ),
          TextButton(
            onPressed: () async {
              await _saveSettings();
              Navigator.of(context).pop(true);
            },
            child: const Text('예', style: TextStyle(color: Color(0xFF4CAF50))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
          leading: IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: Colors.white, size: 24),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingsItem('Mode', _mode, _buildModeDropdown),
                _buildSettingsItem('Word Count', '$_wordCount ${_mode == '단어' ? '단어' : '문장'}', _buildWordCountDropdown),
                _buildSettingsItem('Language', _language, _buildLanguageDropdown),
                _buildSettingsItem('Target Speed', '$_targetSpeed 타/분', _buildTargetSpeedSlider),
                const SizedBox(height: 24),
                _buildBackToGameButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, String value, Widget Function() buildWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        buildWidget(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildModeDropdown() {
    return DropdownButton<String>(
      value: _mode,
      dropdownColor: const Color(0xFF2C2C2C),
      isExpanded: true,
      items: ['단어', '문장'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _updateSetting(() {
            _mode = newValue;
            widget.onModeChanged?.call(newValue);
          });
        }
      },
    );
  }

  Widget _buildWordCountDropdown() {
    return DropdownButton<int>(
      value: _wordCount,
      dropdownColor: const Color(0xFF2C2C2C),
      isExpanded: true,
      items: [10, 20, 30, 40, 50].map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('$value ${_mode == '단어' ? '단어' : '문장'}', style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (int? newValue) {
        if (newValue != null) {
          _updateSetting(() {
            _wordCount = newValue;
            widget.onWordCountChanged?.call(newValue);
          });
        }
      },
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: _language,
      dropdownColor: const Color(0xFF2C2C2C),
      isExpanded: true,
      items: ['영어', '한국어'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _updateSetting(() {
            _language = newValue;
            widget.onLanguageChanged?.call(newValue);
          });
        }
      },
    );
  }

  Widget _buildTargetSpeedSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('목표 타수: $_targetSpeed 타/분', style: const TextStyle(color: Colors.white)),
        Slider(
          value: _targetSpeed.toDouble(),
          min: 100,
          max: 500,
          divisions: 40,
          label: _targetSpeed.round().toString(),
          activeColor: const Color(0xFF4CAF50),
          inactiveColor: const Color(0xFF2C2C2C),
          onChanged: (double newValue) {
            _updateSetting(() {
              _targetSpeed = newValue.round();
              widget.onTargetSpeedChanged?.call(newValue.round());
            });
          },
        ),
      ],
    );
  }

  Widget _buildBackToGameButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C2C2C),
        ),
        onPressed: () async {
          if (_settingsChanged) {
            final shouldSave = await _showSaveConfirmationDialog();
            if (shouldSave == true) {
              await _saveSettings();
            }
          }
          Get.back();
        },
        child: const Text(
          'Back to Game',
          style: TextStyle(color: Color(0xFF4CAF50), fontSize: 16),
        ),
      ),
    );
  }
}
