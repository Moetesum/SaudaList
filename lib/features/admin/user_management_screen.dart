import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neumorphic_theme.dart';
import '../../state/app_state.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.watch<AppState>().users;

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text(
          'User Management',
          style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NeumorphicContainer(
              radius: 16,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: NeumorphicStyles.raised(radius: 12),
                    child: Icon(
                      user.isAdmin ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
                      color: NeumorphicColors.accentGreen,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: NeumorphicColors.textPrimary,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: NeumorphicColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    user.isAdmin ? 'Admin' : 'Shopper',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: NeumorphicColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
