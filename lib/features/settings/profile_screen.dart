import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('Profile & Settings', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: NeumorphicStyles.raised(radius: 50),
                child: const Icon(Icons.person_rounded, size: 60, color: NeumorphicColors.accentGreen),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sauda User',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
            ),
            const SizedBox(height: 4),
            const Text(
              'user@saudalist.com',
              style: TextStyle(color: NeumorphicColors.textSecondary),
            ),
            const SizedBox(height: 30),
            NeumorphicContainer(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_rounded, color: NeumorphicColors.accentGreen),
                    title: const Text('Notifications', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
                    trailing: Switch(
                      value: true,
                      activeColor: NeumorphicColors.accentGreen,
                      onChanged: (val) {},
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_rounded, color: NeumorphicColors.accentGreen),
                    title: const Text('Dark Mode', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
                    trailing: Switch(
                      value: false,
                      activeColor: NeumorphicColors.accentGreen,
                      onChanged: (val) {},
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: NeumorphicColors.accentGreen),
                    title: const Text('About SaudaList', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: NeumorphicColors.textSecondary),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            NeumorphicButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
