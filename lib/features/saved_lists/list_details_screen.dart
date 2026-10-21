import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';

class ListDetailsScreen extends StatelessWidget {
  const ListDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('List Details', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: NeumorphicColors.accentGreen),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.pdfPreview),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: NeumorphicContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: index % 2 == 0,
                        activeColor: NeumorphicColors.accentGreen,
                        onChanged: (val) {},
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Item Name #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NeumorphicColors.textPrimary)),
                          const SizedBox(height: 4),
                          const Text('Qty: 2 • Category: Groceries', style: TextStyle(color: NeumorphicColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    onPressed: () {},
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
