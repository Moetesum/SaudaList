import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        title: const Text('SaudaList Home', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded, color: NeumorphicColors.accentGreen),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            const NeumorphicTextField(
              hintText: 'Search items, categories or lists...',
              prefixIcon: Icons.search_rounded,
            ),
            const SizedBox(height: 24),
            // Quick Navigation Cards
            Row(
              children: [
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.categories),
                    child: const Column(
                      children: [
                        Icon(Icons.category_rounded, size: 32, color: NeumorphicColors.accentGreen),
                        SizedBox(height: 8),
                        Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.myLists),
                    child: const Column(
                      children: [
                        Icon(Icons.list_alt_rounded, size: 32, color: NeumorphicColors.accentGreen),
                        SizedBox(height: 8),
                        Text('My Lists', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.products),
                    child: const Column(
                      children: [
                        Icon(Icons.shopping_bag_rounded, size: 32, color: NeumorphicColors.accentGreen),
                        SizedBox(height: 8),
                        Text('Products', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.pdfPreview),
                    child: const Column(
                      children: [
                        Icon(Icons.picture_as_pdf_rounded, size: 32, color: NeumorphicColors.accentGreen),
                        SizedBox(height: 8),
                        Text('PDF Preview', style: TextStyle(fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Recent Active Lists',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
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
                              child: const Icon(Icons.shopping_cart, color: NeumorphicColors.accentGreen),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Weekly Groceries #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NeumorphicColors.textPrimary)),
                                const SizedBox(height: 4),
                                const Text('12 items • Pending', style: TextStyle(color: NeumorphicColors.textSecondary)),
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
          ],
        ),
      ),
    );
  }
}
