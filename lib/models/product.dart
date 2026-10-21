class Product {
  final String id;
  final String categoryId;
  final String name;
  final String defaultUnit;
  final String? imagePath;
  final bool isActive;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.defaultUnit,
    this.imagePath,
    this.isActive = true,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      defaultUnit: json['default_unit'] as String,
      imagePath: json['image_path'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'default_unit': defaultUnit,
      'image_path': imagePath,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
