import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';

class MyListsScreen extends StatelessWidget {
  const MyListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('My Shopping Lists', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: NeumorphicContainer(
              onTap: () => Navigator.pushNamed(context, AppRoutes.listDetails),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: NeumorphicStyles.raised(radius: 12),
                        child: const Icon(Icons.list_alt_rounded, color: NeumorphicColors.accentGreen),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Grocery List #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NeumorphicColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text('${(index + 3) * 2} items • Created Today', style: const TextStyle(color: NeumorphicColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: NeumorphicColors.textSecondary),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: NeumorphicColors.accentGreen,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create new list tapped')),
          );
        },
      ),
    );
  }
}
