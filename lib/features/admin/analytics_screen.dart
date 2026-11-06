import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neumorphic_theme.dart';
import '../../state/app_state.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final checked = state.lists.fold<int>(
      0,
      (sum, list) => sum + list.items.where((item) => item.isChecked).length,
    );
    final totalItems = state.lists.fold<int>(0, (sum, list) => sum + list.items.length);

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text(
          'Analytics & Logs',
          style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatRow(label: 'Registered users', value: '${state.users.length}'),
          _StatRow(label: 'Shopping lists', value: '${state.lists.length}'),
          _StatRow(label: 'Catalog products', value: '${state.products.length}'),
          _StatRow(label: 'Categories', value: '${state.categories.length}'),
          _StatRow(label: 'Checked items', value: '$checked / $totalItems'),
          const SizedBox(height: 20),
          const Text(
            'Activity log',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: NeumorphicColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...state.activity.map(
            (log) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NeumorphicContainer(
                radius: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: NeumorphicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      log.subtitle,
                      style: const TextStyle(color: NeumorphicColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeumorphicContainer(
        radius: 14,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: NeumorphicColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
