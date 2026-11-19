import 'package:flutter/material.dart';

import '../../core/theme/neumorphic_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text(
          'Analytics & Logs',
          style: TextStyle(
            color: NeumorphicColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Analytics and activity logs coming in Phase 4',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: NeumorphicColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
