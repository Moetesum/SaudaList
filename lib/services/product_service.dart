import '../models/product.dart';
import 'supabase_service.dart';

class ProductService {
  final SupabaseService _supabase = SupabaseService();

  Future<List<Product>> getActiveProducts() async {
    final response = await _supabase.client
        .from('products')
        .select()
        .eq('is_active', true)
        .order('name', ascending: true);

    return (response as List).map((json) => Product.fromJson(json)).toList();
  }
}
