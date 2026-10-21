import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<String> categories = const [
    'Fruits & Vegetables',
    'Dairy & Breakfast',
    'Munchies & Snacks',
    'Cold Drinks & Juices',
    'Instant & Frozen Food',
    'Tea, Coffee & Health Drinks',
    'Bakery & Biscuits',
    'Atta, Rice & Dal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('Categories', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return NeumorphicContainer(
            onTap: () => Navigator.pushNamed(context, AppRoutes.products),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: NeumorphicStyles.raised(radius: 16),
                  child: const Icon(Icons.category_rounded, size: 36, color: NeumorphicColors.accentGreen),
                ),
                const SizedBox(height: 12),
                Text(
                  categories[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: NeumorphicColors.textPrimary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
