import '../models/category.dart';
import 'supabase_service.dart';

class CategoryService {
  final SupabaseService _supabase = SupabaseService();

  Future<List<Category>> getActiveCategories() async {
    try {
      final response = await _supabase.client
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      return (response as List).map((json) => Category.fromJson(json)).toList();
    } catch (_) {
      // Fallback sample categories for demo / offline UI
      return [
        Category(id: '1', name: 'Fruits & Vegetables'),
        Category(id: '2', name: 'Dairy & Breakfast'),
        Category(id: '3', name: 'Munchies & Snacks'),
        Category(id: '4', name: 'Cold Drinks & Juices'),
        Category(id: '5', name: 'Instant & Frozen Food'),
        Category(id: '6', name: 'Bakery & Biscuits'),
      ];
    }
  }
}
