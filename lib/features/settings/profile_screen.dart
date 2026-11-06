import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';
import '../../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

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
            Text(
              user?.name ?? 'Sauda Guest',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'Not signed in',
              style: const TextStyle(color: NeumorphicColors.textSecondary),
            ),
            const SizedBox(height: 30),
            NeumorphicContainer(
              child: Column(
                children: [
                  if (state.isAdmin) ...[
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings_rounded, color: NeumorphicColors.accentGreen),
                      title: const Text('Admin Dashboard', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: NeumorphicColors.textSecondary),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.admin),
                    ),
                    const Divider(),
                  ],
                  ListTile(
                    leading: const Icon(Icons.notifications_rounded, color: NeumorphicColors.accentGreen),
                    title: const Text('Notifications', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
                    trailing: Switch(
                      value: state.notificationsEnabled,
                      activeThumbColor: NeumorphicColors.accentGreen,
                      onChanged: state.setNotifications,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_rounded, color: NeumorphicColors.accentGreen),
                    title: const Text('Dark Mode', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
                    trailing: Switch(
                      value: state.darkMode,
                      activeThumbColor: NeumorphicColors.accentGreen,
                      onChanged: state.setDarkMode,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: NeumorphicColors.accentGreen),
                    title: const Text('About SaudaList', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${state.myLists.length} lists • ${state.products.length} products',
                      style: const TextStyle(color: NeumorphicColors.textSecondary, fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: NeumorphicColors.textSecondary),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'SaudaList',
                        applicationVersion: '1.0.0',
                        applicationLegalese: 'Shop Smart, Live Better.',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            NeumorphicButton(
              onPressed: () {
                context.read<AppState>().logout();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
              },
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
