import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/catalog_look.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../models/product.dart';
import '../../state/app_state.dart';

class ProductsScreen extends StatefulWidget {
  final String? categoryId;
  final String? searchQuery;

  const ProductsScreen({super.key, this.categoryId, this.searchQuery});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late TextEditingController _searchController;
  Timer? _debounce;
  String? _selectedCategoryId;
  String _searchQueryText = '';

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    _searchQueryText = widget.searchQuery ?? '';
    _searchController = TextEditingController(text: _searchQueryText);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQueryText = query;
        });
      }
    });
  }

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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: NeumorphicColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicButton(
                        onPressed: () {
                          if (quantity > 1) setSheetState(() => quantity--);
                        },
                        child: const Icon(
                          Icons.remove,
                          color: NeumorphicColors.accentGreen,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: NeumorphicColors.textPrimary,
                          ),
                        ),
                      ),
                      NeumorphicButton(
                        onPressed: () => setSheetState(() => quantity++),
                        child: const Icon(
                          Icons.add,
                          color: NeumorphicColors.accentGreen,
                        ),
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
                        SnackBar(
                          content: Text(
                            'Added $quantity ${product.name} to $listTitle',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Add to Shopping List',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: NeumorphicColors.accentGreen,
                      ),
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

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categories = state.categories;
    final products = state.catalog(
      categoryId: _selectedCategoryId,
      searchQuery: _searchQueryText,
    );

    String appBarTitle = 'Products Catalog';
    if (_selectedCategoryId != null) {
      appBarTitle =
          state.categoryById(_selectedCategoryId!)?.name ?? 'Products';
    } else if (_searchQueryText.isNotEmpty) {
      appBarTitle = 'Search: $_searchQueryText';
    }

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: NeumorphicColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: NeumorphicColors.accentGreen,
        onRefresh: () => state.loadCatalog(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            NeumorphicTextField(
              controller: _searchController,
              hintText: 'Search products...',
              prefixIcon: Icons.search_rounded,
              onSubmitted: (_) {},
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: _selectedCategoryId == null,
                      onSelected: (selected) {
                        setState(() => _selectedCategoryId = null);
                      },
                      selectedColor: NeumorphicColors.accentGreen.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ),
                  for (final cat in categories)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: _selectedCategoryId == cat.id,
                        onSelected: (selected) {
                          setState(
                            () =>
                                _selectedCategoryId = selected ? cat.id : null,
                          );
                        },
                        selectedColor: NeumorphicColors.accentGreen.withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (state.isLoadingCatalog && state.products.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: CircularProgressIndicator(
                    color: NeumorphicColors.accentGreen,
                  ),
                ),
              )
            else if (state.catalogError != null && state.products.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Text(
                      state.catalogError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    NeumorphicButton(
                      onPressed: () => state.loadCatalog(),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: NeumorphicColors.accentGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (state.products.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    'No products in catalog.',
                    style: TextStyle(color: NeumorphicColors.textSecondary),
                  ),
                ),
              )
            else if (products.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    'No products match your search or filter.',
                    style: TextStyle(color: NeumorphicColors.textSecondary),
                  ),
                ),
              )
            else
              ...List.generate(products.length, (index) {
                final item = products[index];
                final categoryName =
                    state.categoryById(item.categoryId)?.name ?? 'Groceries';
                final look = CatalogLook.forProduct(
                  name: item.name,
                  categoryName: categoryName,
                );
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
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            color: NeumorphicColors.accentGreen,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
