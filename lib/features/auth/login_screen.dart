import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: NeumorphicStyles.raised(radius: 30),
                  child: const Icon(
                    Icons.shopping_cart_rounded,
                    size: 60,
                    color: NeumorphicColors.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: NeumorphicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue to SaudaList',
                style: TextStyle(
                  fontSize: 16,
                  color: NeumorphicColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              const NeumorphicTextField(
                hintText: 'Email or Mobile Number',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const NeumorphicTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: NeumorphicColors.accentGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              NeumorphicButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NeumorphicColors.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: NeumorphicColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                      child: const Text(
                        'Sign Up',
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
