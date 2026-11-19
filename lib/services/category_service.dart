import '../models/category.dart';
import 'supabase_service.dart';

class CategoryService {
  final SupabaseService _supabase = SupabaseService();

  Future<List<Category>> getActiveCategories() async {
    final response = await _supabase.client
        .from('categories')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (response as List).map((json) => Category.fromJson(json)).toList();
  }
}
