import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemTile({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            item['name']?.isNotEmpty == true
                ? item['name'][0].toUpperCase()
                : '?',
            style: TextStyle(color: Colors.blue.shade700),
          ),
        ),
        title: Text(
          item['name'] ?? 'Untitled',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item['description']?.isNotEmpty ?? false)
              Text(
                item['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Row(
              children: [
                if (item['price']?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      'Price: \$${item['price']}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                if (item['category']?.isNotEmpty ?? false)
                  Text(
                    item['category'],
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
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
        onTap: onEdit,
      ),
    );
  }
}