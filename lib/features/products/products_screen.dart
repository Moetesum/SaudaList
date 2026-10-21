import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  void _showQuantitySheet(BuildContext context, String productName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NeumorphicColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int quantity = 1;
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Quantity for $productName',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicButton(
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
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
                        onPressed: () => setState(() => quantity++),
                        child: const Icon(Icons.add, color: NeumorphicColors.accentGreen),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  NeumorphicButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added $quantity $productName to list!')),
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

  @override
  Widget build(BuildContext context) {
    final List<String> products = ['Fresh Organic Milk', 'Whole Wheat Bread', 'Alphonso Mangoes', 'Green Spinach', 'Basmati Rice 5kg', 'Cold Pressed Olive Oil'];

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('Products', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: NeumorphicContainer(
              onTap: () => _showQuantitySheet(context, products[index]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: NeumorphicStyles.raised(radius: 12),
                        child: const Icon(Icons.shopping_bag, color: NeumorphicColors.accentGreen),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(products[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NeumorphicColors.textPrimary)),
                          const SizedBox(height: 4),
                          const Text('Sample Item • Tap to set quantity', style: TextStyle(color: NeumorphicColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.add_shopping_cart_rounded, color: NeumorphicColors.accentGreen),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
