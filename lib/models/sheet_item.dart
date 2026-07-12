class SheetItem {
  final String id;
  final Map<String, String> data;
  final int rowIndex;

  SheetItem({required this.id, required this.data, required this.rowIndex});

  SheetItem copyWith({String? id, Map<String, String>? data, int? rowIndex}) {
    return SheetItem(
      id: id ?? this.id,
      data: data ?? this.data,
      rowIndex: rowIndex ?? this.rowIndex,
    );
  }
}
