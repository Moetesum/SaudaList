import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_theme.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('PDF Preview', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: NeumorphicColors.accentGreen),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF downloaded successfully!')),
              );
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, size: 80, color: NeumorphicColors.accentGreen),
                      const SizedBox(height: 16),
                      const Text(
                        'SaudaList_Grocery_Invoice.pdf',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: NeumorphicColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Page 1 of 1 • 6 Items',
                        style: TextStyle(color: NeumorphicColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            NeumorphicButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing PDF...')),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share_rounded, color: NeumorphicColors.accentGreen),
                  SizedBox(width: 8),
                  Text(
                    'Share PDF',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NeumorphicColors.accentGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
