import 'package:flutter/material.dart';

import '../models/activity_log.dart';
import '../models/app_user.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/shopping_list.dart';
import '../models/shopping_list_item.dart';
import '../services/auth_service.dart';

class AppState extends ChangeNotifier {
  final AuthService _authService;

  AppState({AuthService? authService})
    : _authService = authService ?? SupabaseAuthService();

  AppUser? currentUser;
  bool darkMode = false;
  bool notificationsEnabled = true;
  String? errorMessage;

  final List<AppUser> users = [];
  final List<Category> categories = [];
  final List<Product> products = [];
  final List<ShoppingListModel> lists = [];
  final List<ActivityLog> activity = [];

  String? activeListId;

  bool get isAuthenticated => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;

  Future<void> bootstrap() async {
    try {
      errorMessage = null;
      currentUser = await _authService.getCurrentUser();
    } catch (e) {
      errorMessage = e.toString();
      currentUser = null;
    }
    notifyListeners();
  }

  List<ShoppingListModel> listsForUser(String userId) {
    final owned = lists.where((list) => list.userId == userId).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return owned;
  }

  List<ShoppingListModel> get myLists =>
      currentUser == null ? [] : listsForUser(currentUser!.id);

  ShoppingListModel? listById(String? id) {
    if (id == null) return null;
    try {
      return lists.firstWhere((list) => list.id == id);
    } catch (_) {
      return null;
    }
  }

  Category? categoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (_) {
      return null;
    }
  }

  String categoryNameForItem(ShoppingListItem item) {
    if (item.productId == null) return 'Custom';
    try {
      final product = products.firstWhere(
        (product) => product.id == item.productId,
      );
      return categoryById(product.categoryId)?.name ?? 'Groceries';
    } catch (_) {
      return 'Groceries';
    }
  }

  List<Product> catalog({String? categoryId, String? searchQuery}) {
    final query = searchQuery?.trim().toLowerCase() ?? '';
    return products.where((product) {
      if (!product.isActive) return false;
      if (categoryId != null && product.categoryId != categoryId) return false;
      if (query.isNotEmpty && !product.name.toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<String?> login(String email, String password) async {
    try {
      errorMessage = null;
      currentUser = await _authService.signIn(email: email, password: password);
      notifyListeners();
      return null;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return errorMessage;
    }
  }

  Future<String?> signUp(String name, String email, String password) async {
    if (name.trim().isEmpty) return 'Enter your full name.';
    if (email.trim().isEmpty) return 'Enter an email address.';
    if (password.length < 6) return 'Password must be at least 6 characters.';

    try {
      errorMessage = null;
      currentUser = await _authService.signUp(
        name: name,
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return errorMessage;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (_) {}
    currentUser = null;
    lists.clear();
    activeListId = null;
    notifyListeners();
  }

  Future<String?> resetPassword(String email) async {
    if (email.trim().isEmpty) return 'Enter your email address.';
    try {
      await _authService.resetPassword(email: email);
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  void setDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  ShoppingListModel ensureActiveList() {
    final user = currentUser;
    if (user == null) {
      throw StateError('Not signed in');
    }
    final existing = listById(activeListId);
    if (existing != null && existing.userId == user.id) {
      return existing;
    }
    if (myLists.isNotEmpty) {
      activeListId = myLists.first.id;
      return myLists.first;
    }
    return createList('My Shopping List');
  }

  ShoppingListModel createList(String title, {bool silent = false}) {
    final user = currentUser;
    if (user == null) {
      throw StateError('Not signed in');
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();
    final list = ShoppingListModel(
      id: id,
      userId: user.id,
      title: title.trim().isEmpty ? 'Untitled List' : title.trim(),
      createdAt: now,
      updatedAt: now,
    );
    lists.insert(0, list);
    activeListId = id;
    notifyListeners();
    return list;
  }

  void addProductToActiveList({
    required String productName,
    required double quantity,
    required String unit,
    String? productId,
  }) {
    final list = ensureActiveList();
    final existingIndex = list.items.indexWhere(
      (item) =>
          item.productName.toLowerCase() == productName.toLowerCase() &&
          !item.isChecked,
    );

    List<ShoppingListItem> nextItems;
    if (existingIndex >= 0) {
      final existing = list.items[existingIndex];
      nextItems = [...list.items];
      nextItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      nextItems = [
        ...list.items,
        ShoppingListItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          listId: list.id,
          productId: productId,
          productName: productName,
          quantity: quantity,
          unit: unit,
          sortOrder: list.items.length,
        ),
      ];
    }

    _replaceList(list.copyWith(items: nextItems, updatedAt: DateTime.now()));
  }

  void toggleItem(String listId, String itemId) {
    final list = listById(listId);
    if (list == null) return;
    final nextItems = list.items
        .map(
          (item) => item.id == itemId
              ? item.copyWith(isChecked: !item.isChecked)
              : item,
        )
        .toList();
    _replaceList(list.copyWith(items: nextItems, updatedAt: DateTime.now()));
  }

  void deleteItem(String listId, String itemId) {
    final list = listById(listId);
    if (list == null) return;
    _replaceList(
      list.copyWith(
        items: list.items.where((item) => item.id != itemId).toList(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void _replaceList(ShoppingListModel updated) {
    final index = lists.indexWhere((list) => list.id == updated.id);
    if (index >= 0) {
      lists[index] = updated;
      notifyListeners();
    }
  }
}
