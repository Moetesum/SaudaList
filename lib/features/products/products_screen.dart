import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/catalog_look.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../models/product.dart';
import '../../state/app_state.dart';

class ProductsScreen extends StatelessWidget {
  final String? categoryId;
  final String? searchQuery;

  const ProductsScreen({super.key, this.categoryId, this.searchQuery});

  void _showQuantitySheet(BuildContext context, Product product) {
    var quantity = 1;
    final pageContext = context;
    showModalBottomSheet(
      context: context,
      backgroundColor: NeumorphicColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Quantity for ${product.name}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicButton(
                        onPressed: () {
                          if (quantity > 1) setSheetState(() => quantity--);
                        },
                        child: const Icon(Icons.remove, color: NeumorphicColors.accentGreen),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
                        ),
                      ),
                      NeumorphicButton(
                        onPressed: () => setSheetState(() => quantity++),
                        child: const Icon(Icons.add, color: NeumorphicColors.accentGreen),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  NeumorphicButton(
                    onPressed: () {
                      final appState = context.read<AppState>();
                      appState.addProductToActiveList(
                        productName: product.name,
                        quantity: quantity.toDouble(),
                        unit: product.defaultUnit,
                        productId: product.id,
                      );
                      final listTitle = appState.ensureActiveList().title;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(pageContext).showSnackBar(
                        SnackBar(content: Text('Added $quantity ${product.name} to $listTitle')),
                      );
                    },
                    child: const Text(
                      'Add to Shopping List',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NeumorphicColors.accentGreen),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addProduct(BuildContext context, AppState state) async {
    if (state.categories.isEmpty) return;
    final nameController = TextEditingController();
    final unitController = TextEditingController(text: 'pcs');
    var selectedCategory = categoryId ?? state.categories.first.id;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Product name'),
                  ),
                  TextField(
                    controller: unitController,
                    decoration: const InputDecoration(hintText: 'Unit (kg, litre, packet)'),
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: state.categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setDialogState(() => selectedCategory = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add')),
              ],
            );
          },
        );
      },
    );

    if (saved == true && nameController.text.trim().isNotEmpty && context.mounted) {
      context.read<AppState>().addCatalogProduct(
            name: nameController.text,
            categoryId: selectedCategory,
            unit: unitController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final products = state.catalog(categoryId: categoryId, searchQuery: searchQuery);
    final categoryName = categoryId == null ? null : state.categoryById(categoryId!)?.name;

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: Text(
          categoryName ?? (searchQuery?.isNotEmpty == true ? 'Search results' : 'Products Catalog'),
          style: const TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: state.isAdmin
          ? FloatingActionButton(
              backgroundColor: NeumorphicColors.accentGreen,
              onPressed: () => _addProduct(context, state),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: products.isEmpty
          ? const Center(
              child: Text('No products found.', style: TextStyle(color: NeumorphicColors.textSecondary)),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                final look = CatalogLook.forProduct(name: item.name, categoryId: item.categoryId);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: NeumorphicContainer(
                    radius: 16,
                    padding: const EdgeInsets.all(12),
                    onTap: () => _showQuantitySheet(context, item),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: NeumorphicStyles.raised(radius: 14),
                          child: Icon(look.$1, color: look.$2, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: NeumorphicColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Unit: ${item.defaultUnit} • Tap to add',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: NeumorphicColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: NeumorphicStyles.raised(radius: 10),
                          child: const Icon(Icons.add_shopping_cart_rounded, color: NeumorphicColors.accentGreen, size: 20),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
