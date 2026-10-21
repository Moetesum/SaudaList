import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('Reset Password', style: TextStyle(color: NeumorphicColors.textPrimary)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: NeumorphicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your registered email address to receive password reset instructions.',
                style: TextStyle(
                  fontSize: 16,
                  color: NeumorphicColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              const NeumorphicTextField(
                hintText: 'Email Address',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              NeumorphicButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset link sent to email!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Send Reset Link',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NeumorphicColors.accentGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
