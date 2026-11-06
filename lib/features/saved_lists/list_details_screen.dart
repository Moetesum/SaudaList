import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';
import '../../state/app_state.dart';

class ListDetailsScreen extends StatelessWidget {
  final String? listId;

  const ListDetailsScreen({super.key, this.listId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final list = state.listById(listId) ?? (state.myLists.isEmpty ? null : state.myLists.first);

    if (list == null) {
      return Scaffold(
        backgroundColor: NeumorphicColors.background,
        appBar: AppBar(
          backgroundColor: NeumorphicColors.background,
          elevation: 0,
          iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
          title: const Text('List Details', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
        ),
        body: const Center(
          child: Text('List not found.', style: TextStyle(color: NeumorphicColors.textSecondary)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: Text(list.title, style: const TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: NeumorphicColors.accentGreen),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.pdfPreview, arguments: list.id),
          ),
        ],
      ),
      body: list.items.isEmpty
          ? const Center(
              child: Text(
                'This list is empty.\nAdd items from Products.',
                textAlign: TextAlign.center,
                style: TextStyle(color: NeumorphicColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: list.items.length,
              itemBuilder: (context, index) {
                final item = list.items[index];
                final categoryName = state.categoryNameForItem(item);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: NeumorphicContainer(
                    radius: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Checkbox(
                          value: item.isChecked,
                          activeColor: NeumorphicColors.accentGreen,
                          onChanged: (_) => state.toggleItem(list.id, item.id),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: NeumorphicColors.textPrimary,
                                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Qty: ${item.quantity} ${item.unit} • $categoryName',
                                style: const TextStyle(color: NeumorphicColors.textSecondary, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                          onPressed: () => state.deleteItem(list.id, item.id),
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
