class Category {
  final String id;
  final String name;
  final String? imagePath;
  final int sortOrder;
  final bool isActive;
  final DateTime? createdAt;

  Category({
    required this.id,
    required this.name,
    this.imagePath,
    this.sortOrder = 0,
    this.isActive = true,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: json['image_path'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_path': imagePath,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
