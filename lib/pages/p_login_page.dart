import 'package:flutter/material.dart';
import 'package:tajjang/widgets/w_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAFA),
        title: const Text('TaJJang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings functionality
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF7FAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildWelcomeText(),
                        _buildInputField('Email/ID', _emailController),
                        _buildInputField('Password', _passwordController, isPassword: true),
                        _buildForgotPasswordText(),
                        _buildButtons(),
                        _buildSocialLoginText(),
                        _buildSocialLoginButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Welcome back!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF21190A),
          fontSize: 22,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInputField(String hintText, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: const Color(0xFFF7FAFA),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFD4DBE8)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFFD4DBE8),
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordText() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: GestureDetector(
        onTap: () {
          // TODO: Implement forgot password functionality
        },
        child: const Text(
          'Forgot password?',
          style: TextStyle(
            color: Color(0xFF111416),
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        _buildButton('Log in', const Color(0xFFF9C638), const Color(0xFF141C24), _handleLogin),
        const SizedBox(height: 12),
        _buildButton('Sign up', const Color(0xFFF4EFDB), const Color(0xFF21190A), _handleSignUp),
      ],
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Button(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'Or log in with social media',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFA07C1C),
          fontSize: 14,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton('Apple', _handleAppleLogin),
        const SizedBox(width: 12),
        _buildSocialButton('Facebook', _handleFacebookLogin),
        const SizedBox(width: 12),
        _buildSocialButton('Google', _handleGoogleLogin),
      ],
    );
  }

  Widget _buildSocialButton(String text, VoidCallback onPressed) {
    return Button(
      color: Colors.white,
      border: Border.all(width: 1, color: const Color(0xFFEFE2C1)),
      borderRadius: BorderRadius.circular(12),
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF21190A),
          fontSize: 14,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleLogin() {
    // TODO: Implement login functionality
    print('Login with: ${_emailController.text}');
  }

  void _handleSignUp() {
    // TODO: Implement sign up functionality
    print('Sign up');
  }

  void _handleAppleLogin() {
    // TODO: Implement Apple login
    print('Apple login');
  }

  void _handleFacebookLogin() {
    // TODO: Implement Facebook login
    print('Facebook login');
  }

  void _handleGoogleLogin() {
    // TODO: Implement Google login
    print('Google login');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
