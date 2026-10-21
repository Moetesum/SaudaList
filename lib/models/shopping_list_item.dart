class ShoppingListItem {
  final String id;
  final String listId;
  final String? productId;
  final String productName;
  final double quantity;
  final String unit;
  final bool isChecked;
  final int sortOrder;

  ShoppingListItem({
    required this.id,
    required this.listId,
    this.productId,
    required this.productName,
    required this.quantity,
    required this.unit,
    this.isChecked = false,
    this.sortOrder = 0,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'] as String,
      listId: json['list_id'] as String,
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      isChecked: json['is_checked'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'list_id': listId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit': unit,
      'is_checked': isChecked,
      'sort_order': sortOrder,
    };
  }
}
