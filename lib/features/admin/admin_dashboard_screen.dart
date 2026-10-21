import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        title: const Text('Admin Web Panel - Dashboard', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
            ),
            const SizedBox(height: 20),
            // Metrics Row
            Row(
              children: [
                Expanded(
                  child: NeumorphicContainer(
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Users', style: TextStyle(color: NeumorphicColors.textSecondary)),
                        SizedBox(height: 8),
                        Text('1,420', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: NeumorphicColors.accentGreen)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NeumorphicContainer(
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Active Lists', style: TextStyle(color: NeumorphicColors.textSecondary)),
                        SizedBox(height: 8),
                        Text('3,890', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: NeumorphicColors.accentGreen)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NeumorphicContainer(
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Products', style: TextStyle(color: NeumorphicColors.textSecondary)),
                        SizedBox(height: 8),
                        Text('520', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: NeumorphicColors.accentGreen)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Quick Admin Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                NeumorphicButton(
                  onPressed: () {},
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_rounded, color: NeumorphicColors.accentGreen),
                      SizedBox(height: 8),
                      Text('User Management', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                    ],
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_rounded, color: NeumorphicColors.accentGreen),
                      SizedBox(height: 8),
                      Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                    ],
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_rounded, color: NeumorphicColors.accentGreen),
                      SizedBox(height: 8),
                      Text('Product Catalog', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                    ],
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.analytics_rounded, color: NeumorphicColors.accentGreen),
                      SizedBox(height: 8),
                      Text('Analytics', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                    ],
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings_rounded, color: NeumorphicColors.accentGreen),
                      SizedBox(height: 8),
                      Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                    ],
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.redAccent),
                      SizedBox(height: 8),
                      Text('Logout Admin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
