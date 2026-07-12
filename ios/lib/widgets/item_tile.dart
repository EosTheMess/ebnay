import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemTile({super.key, required this.item, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final name = item['name'] ?? 'Untitled';
    final price = item['price'] ?? 'N/A';
    final category = item['category'] ?? 'Uncategorized';
    final description = item['description'] ?? 'No description';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$price | $category'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(name),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Price: $price'),
                  Text('Category: $category'),
                  Text('Description: $description'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
