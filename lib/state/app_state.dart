import 'package:flutter/material.dart';

import '../models/activity_log.dart';
import '../models/app_user.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/shopping_list.dart';
import '../models/shopping_list_item.dart';

class AppState extends ChangeNotifier {
  AppUser? currentUser;
  bool darkMode = false;
  bool notificationsEnabled = true;

  final List<AppUser> users = [];
  final List<Category> categories = [];
  final List<Product> products = [];
  final List<ShoppingListModel> lists = [];
  final List<ActivityLog> activity = [];

  String? activeListId;
  int _nextId = 100;

  bool get isAuthenticated => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;

  String _id() => '${_nextId++}';

  void bootstrap() {
    users
      ..clear()
      ..addAll([
        AppUser(
          id: 'u-admin',
          name: 'Sauda Admin',
          email: 'admin@saudalist.com',
          password: 'admin123',
          isAdmin: true,
        ),
        AppUser(
          id: 'u-shopper',
          name: 'Sauda User',
          email: 'user@saudalist.com',
          password: 'user123',
        ),
      ]);

    categories
      ..clear()
      ..addAll([
        Category(id: '1', name: 'Fruits & Vegetables', sortOrder: 0),
        Category(id: '2', name: 'Dairy & Breakfast', sortOrder: 1),
        Category(id: '3', name: 'Munchies & Snacks', sortOrder: 2),
        Category(id: '4', name: 'Cold Drinks & Juices', sortOrder: 3),
        Category(id: '5', name: 'Instant & Frozen Food', sortOrder: 4),
        Category(id: '6', name: 'Tea, Coffee & Health Drinks', sortOrder: 5),
        Category(id: '7', name: 'Bakery & Biscuits', sortOrder: 6),
        Category(id: '8', name: 'Atta, Rice & Dal', sortOrder: 7),
      ]);

    products
      ..clear()
      ..addAll([
        Product(id: 'p1', categoryId: '2', name: 'Fresh Organic Milk', defaultUnit: 'litre'),
        Product(id: 'p2', categoryId: '7', name: 'Whole Wheat Bread', defaultUnit: 'loaf'),
        Product(id: 'p3', categoryId: '1', name: 'Alphonso Mangoes', defaultUnit: 'kg'),
        Product(id: 'p4', categoryId: '1', name: 'Green Spinach', defaultUnit: 'bunch'),
        Product(id: 'p5', categoryId: '8', name: 'Basmati Rice 5kg', defaultUnit: 'bag'),
        Product(id: 'p6', categoryId: '8', name: 'Cold Pressed Olive Oil', defaultUnit: 'ml'),
        Product(id: 'p7', categoryId: '2', name: 'Eggs', defaultUnit: 'pcs'),
        Product(id: 'p8', categoryId: '4', name: 'Mango Juice', defaultUnit: 'litre'),
        Product(id: 'p9', categoryId: '3', name: 'Namkeen Mix', defaultUnit: 'packet'),
        Product(id: 'p10', categoryId: '6', name: 'Green Tea', defaultUnit: 'box'),
      ]);

    final now = DateTime.now();
    lists
      ..clear()
      ..add(
        ShoppingListModel(
          id: 'l1',
          userId: 'u-shopper',
          title: 'Weekly Groceries',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now,
          items: [
            ShoppingListItem(id: 'i1', listId: 'l1', productId: 'p1', productName: 'Fresh Organic Milk', quantity: 2, unit: 'litre', isChecked: true),
            ShoppingListItem(id: 'i2', listId: 'l1', productId: 'p2', productName: 'Whole Wheat Bread', quantity: 1, unit: 'loaf'),
            ShoppingListItem(id: 'i3', listId: 'l1', productId: 'p7', productName: 'Eggs', quantity: 12, unit: 'pcs'),
            ShoppingListItem(id: 'i4', listId: 'l1', productId: 'p5', productName: 'Basmati Rice 5kg', quantity: 1, unit: 'bag', isChecked: true),
          ],
        ),
      );

    activity
      ..clear()
      ..addAll([
        ActivityLog(title: 'New Product Added', subtitle: 'Fresh Organic Milk (1L)', at: now.subtract(const Duration(minutes: 10)), iconName: 'add'),
        ActivityLog(title: 'User Access Updated', subtitle: 'editor@saudalist.com verified', at: now.subtract(const Duration(hours: 1)), iconName: 'user'),
        ActivityLog(title: 'Catalog Seeded', subtitle: '${products.length} products in ${categories.length} categories', at: now.subtract(const Duration(hours: 4)), iconName: 'sync'),
      ]);

    currentUser = null;
    activeListId = 'l1';
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
      final product = products.firstWhere((product) => product.id == item.productId);
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
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  AppUser? _userByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    try {
      return users.firstWhere((user) => user.email == normalized);
    } catch (_) {
      return null;
    }
  }

  bool hasAccount(String email) => _userByEmail(email) != null;

  String? login(String email, String password) {
    final user = _userByEmail(email);
    if (user == null) return 'No account found for that email.';
    if (user.password != password) return 'Incorrect password.';
    currentUser = user;
    if (myLists.isNotEmpty) {
      activeListId = myLists.first.id;
    }
    _log('User Signed In', user.email, 'user');
    notifyListeners();
    return null;
  }

  String? loginAsAdminDemo() {
    return login('admin@saudalist.com', 'admin123');
  }

  String? signUp(String name, String email, String password) {
    if (name.trim().isEmpty) return 'Enter your full name.';
    if (email.trim().isEmpty) return 'Enter an email address.';
    if (password.length < 4) return 'Password must be at least 4 characters.';
    if (hasAccount(email)) return 'An account already exists for that email.';

    final user = AppUser(
      id: _id(),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      isAdmin: email.toLowerCase().contains('admin'),
    );
    users.add(user);
    currentUser = user;
    createList('My Shopping List', silent: true);
    _log('New User Registered', user.email, 'user');
    notifyListeners();
    return null;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
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
    if (currentUser == null) {
      throw StateError('Not signed in');
    }
    final existing = listById(activeListId);
    if (existing != null && existing.userId == currentUser!.id) {
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
    final id = _id();
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
    if (!silent) {
      _log('List Created', list.title, 'list');
    }
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
      (item) => item.productName.toLowerCase() == productName.toLowerCase() && !item.isChecked,
    );

    List<ShoppingListItem> nextItems;
    if (existingIndex >= 0) {
      final existing = list.items[existingIndex];
      nextItems = [...list.items];
      nextItems[existingIndex] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      nextItems = [
        ...list.items,
        ShoppingListItem(
          id: _id(),
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
    if (notificationsEnabled) {
      _log('Item Added', '$quantity $unit $productName', 'add');
    }
  }

  void toggleItem(String listId, String itemId) {
    final list = listById(listId);
    if (list == null) return;
    final nextItems = list.items
        .map((item) => item.id == itemId ? item.copyWith(isChecked: !item.isChecked) : item)
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

  void addCategory(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    categories.add(
      Category(
        id: _id(),
        name: trimmed,
        sortOrder: categories.length,
      ),
    );
    _log('Category Added', trimmed, 'add');
    notifyListeners();
  }

  void addCatalogProduct({
    required String name,
    required String categoryId,
    required String unit,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    products.add(
      Product(
        id: _id(),
        categoryId: categoryId,
        name: trimmed,
        defaultUnit: unit.trim().isEmpty ? 'pcs' : unit.trim(),
      ),
    );
    _log('New Product Added', trimmed, 'add');
    notifyListeners();
  }

  void _replaceList(ShoppingListModel updated) {
    final index = lists.indexWhere((list) => list.id == updated.id);
    if (index >= 0) {
      lists[index] = updated;
      notifyListeners();
    }
  }

  void _log(String title, String subtitle, String iconName) {
    activity.insert(0, ActivityLog(title: title, subtitle: subtitle, iconName: iconName));
    if (activity.length > 20) {
      activity.removeLast();
    }
  }
}
