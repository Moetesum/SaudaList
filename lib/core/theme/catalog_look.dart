import 'package:flutter/material.dart';

import 'neumorphic_theme.dart';

class CatalogLook {
  static (IconData, Color) forCategory(String categoryName) {
    final lower = categoryName.toLowerCase();
    if (lower.contains('tea') ||
        lower.contains('coffee') ||
        lower.contains('health')) {
      return (Icons.local_cafe_rounded, const Color(0xFF795548));
    }
    if (lower.contains('fruit') || lower.contains('veg')) {
      return (Icons.eco_rounded, const Color(0xFF4CAF50));
    }
    if (lower.contains('dairy') || lower.contains('breakfast')) {
      return (Icons.egg_alt_rounded, const Color(0xFFFF9800));
    }
    if (lower.contains('snack') || lower.contains('munchie')) {
      return (Icons.fastfood_rounded, const Color(0xFFE91E63));
    }
    if (lower.contains('drink') ||
        lower.contains('juice') ||
        lower.contains('cold')) {
      return (Icons.local_drink_rounded, const Color(0xFF00BCD4));
    }
    if (lower.contains('frozen') || lower.contains('instant')) {
      return (Icons.ac_unit_rounded, const Color(0xFF3F51B5));
    }
    if (lower.contains('bakery') || lower.contains('biscuit')) {
      return (Icons.bakery_dining_rounded, const Color(0xFFFF5722));
    }
    if (lower.contains('rice') ||
        lower.contains('atta') ||
        lower.contains('dal') ||
        lower.contains('grain')) {
      return (Icons.grain_rounded, const Color(0xFF8BC34A));
    }
    return (Icons.category_rounded, NeumorphicColors.primaryGreen);
  }

  static (IconData, Color) forProduct({
    required String name,
    required String categoryName,
  }) {
    final lower = name.toLowerCase();
    if (lower.contains('milk')) {
      return (Icons.local_drink_rounded, const Color(0xFF2196F3));
    }
    if (lower.contains('bread')) {
      return (Icons.bakery_dining_rounded, const Color(0xFFFF9800));
    }
    if (lower.contains('mango')) {
      return (Icons.nature_rounded, const Color(0xFFFFC107));
    }
    if (lower.contains('spinach') || lower.contains('green')) {
      return (Icons.eco_rounded, NeumorphicColors.accentGreen);
    }
    if (lower.contains('rice')) {
      return (Icons.rice_bowl_rounded, const Color(0xFF795548));
    }
    if (lower.contains('oil')) {
      return (Icons.opacity_rounded, const Color(0xFF9E9D24));
    }
    if (lower.contains('egg')) {
      return (Icons.egg_alt_rounded, const Color(0xFFFFC107));
    }
    return forCategory(categoryName);
  }
}
