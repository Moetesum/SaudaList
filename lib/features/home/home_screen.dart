import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';
import '../../state/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final lists = state.myLists;
    final name = state.currentUser?.name.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Sauda',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: NeumorphicColors.primaryGreen,
                ),
              ),
              TextSpan(
                text: 'List',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: NeumorphicColors.accentOrange,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded, color: NeumorphicColors.primaryGreen, size: 28),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shop Smart, $name!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: NeumorphicColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Organize your weekly grocery lists effortlessly.',
                          style: TextStyle(
                            fontSize: 12,
                            color: NeumorphicColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: NeumorphicStyles.raised(radius: 50),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: NeumorphicColors.accentOrange,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            NeumorphicTextField(
              controller: _searchController,
              hintText: 'Search items, categories or lists...',
              prefixIcon: Icons.search_rounded,
              onSubmitted: (value) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.products,
                  arguments: {'searchQuery': value},
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.myLists),
                    child: const Column(
                      children: [
                        Icon(Icons.shopping_cart_rounded, size: 28, color: NeumorphicColors.primaryGreen),
                        SizedBox(height: 6),
                        Text('My List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NeumorphicColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.categories),
                    child: const Column(
                      children: [
                        Icon(Icons.grid_view_rounded, size: 28, color: NeumorphicColors.accentOrange),
                        SizedBox(height: 6),
                        Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NeumorphicColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.products),
                    child: const Column(
                      children: [
                        Icon(Icons.history_rounded, size: 28, color: Color(0xFF3B82F6)),
                        SizedBox(height: 6),
                        Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NeumorphicColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
                    child: const Column(
                      children: [
                        Icon(Icons.settings_rounded, size: 28, color: Color(0xFF8B5CF6)),
                        SizedBox(height: 6),
                        Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: NeumorphicColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'Recent Active Lists',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
            ),
            const SizedBox(height: 14),
            if (lists.isEmpty)
              const NeumorphicContainer(
                child: Text(
                  'No lists yet. Open My List and tap + to create one.',
                  style: TextStyle(color: NeumorphicColors.textSecondary),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lists.take(5).length,
                itemBuilder: (context, index) {
                  final list = lists[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: NeumorphicContainer(
                      radius: 16,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.listDetails, arguments: list.id),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: NeumorphicStyles.raised(radius: 12),
                            child: const Icon(Icons.receipt_long_rounded, color: NeumorphicColors.primaryGreen),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  list.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NeumorphicColors.textPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${list.items.length} items • ${list.statusLabel}',
                                  style: const TextStyle(color: NeumorphicColors.textSecondary, fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
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
