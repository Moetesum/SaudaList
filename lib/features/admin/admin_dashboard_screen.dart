import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';
import '../../state/app_state.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: NeumorphicColors.background,
        appBar: AppBar(
          backgroundColor: NeumorphicColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: NeumorphicColors.textPrimary,
            ),
            onPressed: () => _handleBack(context),
          ),
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              color: NeumorphicColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeumorphicContainer(
                radius: 20,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: NeumorphicStyles.raised(radius: 40),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 34,
                        color: NeumorphicColors.accentGreen,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${state.currentUser?.name ?? 'Admin'}!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: NeumorphicColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'SaudaList System Control',
                            style: TextStyle(
                              fontSize: 12,
                              color: NeumorphicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'System Overview',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: NeumorphicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.35,
                children: const [
                  _MetricCard(
                    title: 'Total Users',
                    value: '-',
                    subtitle: 'Coming in Phase 4',
                    icon: Icons.people_alt_rounded,
                    iconColor: NeumorphicColors.accentGreen,
                  ),
                  _MetricCard(
                    title: 'Active Lists',
                    value: '-',
                    subtitle: 'Coming in Phase 4',
                    icon: Icons.format_list_bulleted_rounded,
                    iconColor: Color(0xFF2196F3),
                  ),
                  _MetricCard(
                    title: 'Products',
                    value: '-',
                    subtitle: 'Coming in Phase 4',
                    icon: Icons.shopping_bag_rounded,
                    iconColor: Color(0xFFFF9800),
                  ),
                  _MetricCard(
                    title: 'Database Status',
                    value: '-',
                    subtitle: 'Coming in Phase 4',
                    icon: Icons.cloud_done_rounded,
                    iconColor: Color(0xFF9C27B0),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Admin Actions',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: NeumorphicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
                children: [
                  _AdminActionTile(
                    icon: Icons.manage_accounts_rounded,
                    label: 'User Management',
                    color: NeumorphicColors.accentGreen,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.userManagement),
                  ),
                  _AdminActionTile(
                    icon: Icons.category_rounded,
                    label: 'Category Manager',
                    color: const Color(0xFF2196F3),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.categories),
                  ),
                  _AdminActionTile(
                    icon: Icons.inventory_2_rounded,
                    label: 'Product Catalog',
                    color: const Color(0xFFFF9800),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.products),
                  ),
                  _AdminActionTile(
                    icon: Icons.insights_rounded,
                    label: 'Analytics & Logs',
                    color: const Color(0xFF9C27B0),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.analytics),
                  ),
                  _AdminActionTile(
                    icon: Icons.settings_applications_rounded,
                    label: 'System Settings',
                    color: const Color(0xFF607D8B),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
                  ),
                  _AdminActionTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout Admin',
                    color: Colors.redAccent,
                    onTap: () async {
                      await context.read<AppState>().logout();
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent System Activity',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: NeumorphicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const NeumorphicContainer(
                radius: 16,
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Activity log coming in Phase 4',
                    style: TextStyle(color: NeumorphicColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      radius: 16,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: NeumorphicColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, size: 20, color: iconColor),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: NeumorphicColors.textPrimary,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: iconColor.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _AdminActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AdminActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onTap,
      radius: 16,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: NeumorphicStyles.raised(radius: 12),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color == Colors.redAccent
                    ? Colors.redAccent
                    : NeumorphicColors.textPrimary,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
