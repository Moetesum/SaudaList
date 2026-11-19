import 'package:flutter/material.dart';
import 'neumorphic_theme.dart';

class CatalogLook {
  static const _styles = <String, (IconData, Color)>{
    '1': (Icons.eco_rounded, Color(0xFF4CAF50)),
    '2': (Icons.egg_alt_rounded, Color(0xFFFF9800)),
    '3': (Icons.fastfood_rounded, Color(0xFFE91E63)),
    '4': (Icons.local_drink_rounded, Color(0xFF00BCD4)),
    '5': (Icons.ac_unit_rounded, Color(0xFF3F51B5)),
    '6': (Icons.local_cafe_rounded, Color(0xFF795548)),
    '7': (Icons.bakery_dining_rounded, Color(0xFFFF5722)),
    '8': (Icons.grain_rounded, Color(0xFF8BC34A)),
  };

  static (IconData, Color) forCategory(String categoryId) {
    return _styles[categoryId] ?? (Icons.category_rounded, NeumorphicColors.primaryGreen);
  }

  static (IconData, Color) forProduct({
    required String name,
    required String categoryId,
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
    return forCategory(categoryId);
  }
}
