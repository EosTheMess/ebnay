import 'package:flutter/material.dart';

class UndoButton extends StatelessWidget {
  final VoidCallback onUndo;
  final String label;

  const UndoButton({
    super.key,
    required this.onUndo,
    this.label = 'Undo',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onUndo,
        icon: const Icon(Icons.undo, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}