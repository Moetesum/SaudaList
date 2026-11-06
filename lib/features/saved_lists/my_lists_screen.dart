import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/neumorphic_theme.dart';
import '../../core/routing/app_router.dart';
import '../../state/app_state.dart';

class MyListsScreen extends StatelessWidget {
  const MyListsScreen({super.key});

  Future<void> _createList(BuildContext context) async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Shopping List'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'List title'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
    if (title != null && title.isNotEmpty && context.mounted) {
      final list = context.read<AppState>().createList(title);
      Navigator.pushNamed(context, AppRoutes.listDetails, arguments: list.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<AppState>().myLists;

    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        backgroundColor: NeumorphicColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeumorphicColors.textPrimary),
        title: const Text('My Shopping Lists', style: TextStyle(color: NeumorphicColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: lists.isEmpty
          ? const Center(
              child: Text(
                'No shopping lists yet.\nTap + to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: NeumorphicColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: lists.length,
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
                          child: const Icon(Icons.list_alt_rounded, color: NeumorphicColors.accentGreen),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NeumorphicColors.textPrimary),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: NeumorphicColors.accentGreen,
        onPressed: () => _createList(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
