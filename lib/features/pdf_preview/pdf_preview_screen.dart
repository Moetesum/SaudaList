import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neumorphic_theme.dart';
import '../../models/shopping_list.dart';
import '../../models/shopping_list_item.dart';
import '../../services/pdf_service.dart';
import '../../state/app_state.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String? listId;
  final ShoppingListModel? shoppingList;

  const PdfPreviewScreen({super.key, this.listId, this.shoppingList});

  ShoppingListModel _fallbackList() => ShoppingListModel(
        id: '1',
        userId: '1',
        title: 'SaudaList Grocery Invoice',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        items: [
          ShoppingListItem(id: '1', listId: '1', productName: 'Milk', quantity: 2, unit: 'Liters', isChecked: true),
          ShoppingListItem(id: '2', listId: '1', productName: 'Bread', quantity: 1, unit: 'Loaf', isChecked: true),
          ShoppingListItem(id: '3', listId: '1', productName: 'Eggs', quantity: 12, unit: 'Pcs', isChecked: false),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final list = shoppingList ?? state.listById(listId) ?? (state.myLists.isNotEmpty ? state.myLists.first : _fallbackList());
    final pdfService = PdfService();

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: Text(list.title, style: const TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded, color: NeumorphicColors.accentGreen),
            onPressed: () async {
              final pdfData = await pdfService.generateListPdf(list);
              await pdfService.printPdf(pdfData);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: NeumorphicContainer(
                radius: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PdfPreview(
                    build: (format) => pdfService.generateListPdf(list),
                    allowPrinting: true,
                    allowSharing: true,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
