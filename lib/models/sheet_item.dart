class SheetItem {
  final String id;
  final String name;
  final String price;
  final String category;
  final String description;

  SheetItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'description': description,
    };
  }

  factory SheetItem.fromMap(Map<String, dynamic> map) {
    return SheetItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
    );
  }
}