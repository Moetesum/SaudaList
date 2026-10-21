import '../models/product.dart';
import 'supabase_service.dart';

class ProductService {
  final SupabaseService _supabase = SupabaseService();

  Future<List<Product>> getActiveProducts({String? categoryId, String? searchQuery}) async {
    try {
      var query = _supabase.client.from('products').select().eq('is_active', true);
      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }
      final response = await query.order('name', ascending: true);
      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (_) {
      // Fallback demo products
      return [
        Product(id: '1', categoryId: '1', name: 'Fresh Organic Milk', defaultUnit: 'litre'),
        Product(id: '2', categoryId: '1', name: 'Whole Wheat Bread', defaultUnit: 'packet'),
        Product(id: '3', categoryId: '1', name: 'Alphonso Mangoes', defaultUnit: 'kg'),
        Product(id: '4', categoryId: '1', name: 'Green Spinach', defaultUnit: 'bunch'),
        Product(id: '5', categoryId: '1', name: 'Basmati Rice 5kg', defaultUnit: 'bag'),
      ];
    }
  }
}
