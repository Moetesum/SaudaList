import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('Create Account', style: TextStyle(color: NeumorphicColors.textPrimary)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Join SaudaList',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: NeumorphicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your account to manage shopping lists effortlessly',
                style: TextStyle(
                  fontSize: 16,
                  color: NeumorphicColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),
              const NeumorphicTextField(
                hintText: 'Full Name',
                prefixIcon: Icons.person_rounded,
              ),
              const SizedBox(height: 20),
              const NeumorphicTextField(
                hintText: 'Email Address',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const NeumorphicTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              NeumorphicButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NeumorphicColors.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: NeumorphicColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: NeumorphicColors.accentGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
