import '../models/shopping_list.dart';
import 'supabase_service.dart';

class ShoppingListService {
  final SupabaseService _supabase = SupabaseService();

  Future<List<ShoppingListModel>> getUserLists() async {
    try {
      final userId = _supabase.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase.client
          .from('shopping_lists')
          .select('*, items:shopping_list_items(*)')
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List).map((json) => ShoppingListModel.fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }
}
