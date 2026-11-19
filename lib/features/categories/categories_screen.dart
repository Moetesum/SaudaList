import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/catalog_look.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';
import '../../state/app_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categories = [...state.categories]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: NeumorphicColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: NeumorphicColors.accentGreen,
        onRefresh: () async {
          await state.loadCatalog();
          if (!context.mounted) return;
          if (state.catalogError != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.catalogError!)));
          }
        },
        child: state.isLoadingCatalog && categories.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: CircularProgressIndicator(
                      color: NeumorphicColors.accentGreen,
                    ),
                  ),
                ],
              )
            : state.catalogError != null && categories.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 150),
                  Center(
                    child: Text(
                      state.catalogError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: NeumorphicButton(
                      onPressed: () => state.loadCatalog(),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: NeumorphicColors.accentGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : categories.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 150),
                  Center(
                    child: Text(
                      'No categories available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: NeumorphicColors.textSecondary),
                    ),
                  ),
                ],
              )
            : GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.92,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final look = CatalogLook.forCategory(cat.name);
                  return NeumorphicContainer(
                    radius: 18,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.products,
                      arguments: {'categoryId': cat.id},
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: NeumorphicStyles.raised(radius: 16),
                          child: Icon(look.$1, size: 32, color: look.$2),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Center(
                            child: Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: NeumorphicColors.textPrimary,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
