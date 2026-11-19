import 'package:flutter_test/flutter_test.dart';
import 'package:saudalist/models/app_user.dart';
import 'package:saudalist/models/category.dart';
import 'package:saudalist/models/product.dart';
import 'package:saudalist/services/auth_service.dart';
import 'package:saudalist/services/category_service.dart';
import 'package:saudalist/services/product_service.dart';
import 'package:saudalist/state/app_state.dart';

class FakeAuthService implements AuthService {
  final AppUser? initialUser;
  final bool shouldThrow;

  FakeAuthService({this.initialUser, this.shouldThrow = false});

  @override
  Future<AppUser?> getCurrentUser() async => initialUser;

  @override
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) throw const AuthFailure('Invalid credentials.');
    return initialUser ??
        AppUser(
          id: 'u1',
          name: 'Test User',
          email: email,
          role: 'customer',
          isActive: true,
        );
  }

  @override
  Future<AppUser?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (shouldThrow) throw const AuthFailure('Sign up failed.');
    return initialUser ??
        AppUser(
          id: 'u1',
          name: name,
          email: email,
          role: 'customer',
          isActive: true,
        );
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resetPassword({required String email}) async {}
}

class FakeCategoryService implements CategoryService {
  final List<Category> categories;
  final bool shouldThrow;
  final Duration delay;

  FakeCategoryService({
    this.categories = const [],
    this.shouldThrow = false,
    this.delay = Duration.zero,
  });

  @override
  Future<List<Category>> getActiveCategories() async {
    if (delay > Duration.zero) await Future.delayed(delay);
    if (shouldThrow) throw Exception('Category network error');
    return categories;
  }
}

class FakeProductService implements ProductService {
  final List<Product> products;
  final bool shouldThrow;
  final Duration delay;

  FakeProductService({
    this.products = const [],
    this.shouldThrow = false,
    this.delay = Duration.zero,
  });

  @override
  Future<List<Product>> getActiveProducts() async {
    if (delay > Duration.zero) await Future.delayed(delay);
    if (shouldThrow) throw Exception('Product network error');
    return products;
  }
}

void main() {
  group('AppState Phase 1b Catalog & Auth Tests', () {
    test(
      'AppState.signUp rejects passwords shorter than 6 characters',
      () async {
        final appState = AppState();
        final result = await appState.signUp(
          'Test User',
          'test@example.com',
          '12345',
        );
        expect(result, equals('Password must be at least 6 characters.'));
        expect(appState.currentUser, isNull);
      },
    );

    test(
      'AppState.login returns AuthFailure message when service throws',
      () async {
        final authService = FakeAuthService(shouldThrow: true);
        final appState = AppState(authService: authService);

        final result = await appState.login(
          'test@example.com',
          'wrongpassword',
        );
        expect(result, equals('Invalid credentials.'));
        expect(appState.errorMessage, equals('Invalid credentials.'));
        expect(appState.currentUser, isNull);
      },
    );

    test('Catalog does not load when logged out', () async {
      final categoryService = FakeCategoryService(
        categories: [Category(id: 'c1', name: 'Fruits')],
      );
      final productService = FakeProductService(
        products: [
          Product(id: 'p1', categoryId: 'c1', name: 'Apple', defaultUnit: 'kg'),
        ],
      );
      final appState = AppState(
        authService: FakeAuthService(initialUser: null),
        categoryService: categoryService,
        productService: productService,
      );

      await appState.loadCatalog();
      expect(appState.categories, isEmpty);
      expect(appState.products, isEmpty);
    });

    test('Catalog loads successfully when logged in', () async {
      final categoryService = FakeCategoryService(
        categories: [Category(id: 'c1', name: 'Fruits')],
      );
      final productService = FakeProductService(
        products: [
          Product(id: 'p1', categoryId: 'c1', name: 'Apple', defaultUnit: 'kg'),
        ],
      );
      final user = AppUser(
        id: 'u1',
        name: 'User',
        email: 'u@test.com',
        role: 'customer',
        isActive: true,
      );

      final appState = AppState(
        authService: FakeAuthService(initialUser: user),
        categoryService: categoryService,
        productService: productService,
      );

      await appState.bootstrap();
      await appState.loadCatalog();
      expect(appState.categories.length, equals(1));
      expect(appState.products.length, equals(1));
      expect(appState.catalogError, isNull);
    });

    test('Catalog handles error gracefully', () async {
      final categoryService = FakeCategoryService(shouldThrow: true);
      final productService = FakeProductService(shouldThrow: true);
      final user = AppUser(
        id: 'u1',
        name: 'User',
        email: 'u@test.com',
        role: 'customer',
        isActive: true,
      );

      final appState = AppState(
        authService: FakeAuthService(initialUser: user),
        categoryService: categoryService,
        productService: productService,
      );

      await appState.bootstrap();
      await appState.loadCatalog();
      expect(appState.categories, isEmpty);
      expect(appState.products, isEmpty);
      expect(
        appState.catalogError,
        equals('Could not load the catalog. Please try again.'),
      );
    });

    test('Catalog re-entrancy returns the same Future', () async {
      final categoryService = FakeCategoryService(
        categories: [Category(id: 'c1', name: 'Fruits')],
        delay: const Duration(milliseconds: 50),
      );
      final productService = FakeProductService(
        products: [
          Product(id: 'p1', categoryId: 'c1', name: 'Apple', defaultUnit: 'kg'),
        ],
      );
      final user = AppUser(
        id: 'u1',
        name: 'User',
        email: 'u@test.com',
        role: 'customer',
        isActive: true,
      );

      final appState = AppState(
        authService: FakeAuthService(initialUser: user),
        categoryService: categoryService,
        productService: productService,
      );

      await appState.bootstrap();
      final f1 = appState.loadCatalog();
      final f2 = appState.loadCatalog();
      expect(f1, same(f2));
      await f1;
    });

    test('Logout clears catalog and discards in-flight result', () async {
      final categoryService = FakeCategoryService(
        categories: [Category(id: 'c1', name: 'Fruits')],
        delay: const Duration(milliseconds: 50),
      );
      final productService = FakeProductService(
        products: [
          Product(id: 'p1', categoryId: 'c1', name: 'Apple', defaultUnit: 'kg'),
        ],
      );
      final user = AppUser(
        id: 'u1',
        name: 'User',
        email: 'u@test.com',
        role: 'customer',
        isActive: true,
      );

      final appState = AppState(
        authService: FakeAuthService(initialUser: user),
        categoryService: categoryService,
        productService: productService,
      );

      await appState.bootstrap();
      final future = appState.loadCatalog();
      await appState.logout();
      await future;

      expect(appState.categories, isEmpty);
      expect(appState.products, isEmpty);
      expect(appState.currentUser, isNull);
    });

    test('Login succeeds even when catalog load fails', () async {
      final categoryService = FakeCategoryService(shouldThrow: true);
      final productService = FakeProductService(shouldThrow: true);
      final authService = FakeAuthService(shouldThrow: false);

      final appState = AppState(
        authService: authService,
        categoryService: categoryService,
        productService: productService,
      );

      final error = await appState.login('user@test.com', 'password123');
      expect(error, isNull);
      expect(appState.currentUser, isNotNull);
      // Give time for unawaited catalog load to complete with error
      await Future.delayed(const Duration(milliseconds: 20));
      expect(
        appState.catalogError,
        equals('Could not load the catalog. Please try again.'),
      );
    });

    test('Filter catalog by category and search query', () async {
      final user = AppUser(
        id: 'u1',
        name: 'User',
        email: 'u@test.com',
        role: 'customer',
        isActive: true,
      );
      final appState = AppState(
        authService: FakeAuthService(initialUser: user),
        categoryService: FakeCategoryService(
          categories: [
            Category(id: 'c1', name: 'Dairy'),
            Category(id: 'c2', name: 'Bakery'),
          ],
        ),
        productService: FakeProductService(
          products: [
            Product(
              id: 'p1',
              categoryId: 'c1',
              name: 'Fresh Organic Milk',
              defaultUnit: 'litre',
            ),
            Product(
              id: 'p2',
              categoryId: 'c2',
              name: 'Whole Wheat Bread',
              defaultUnit: 'loaf',
            ),
          ],
        ),
      );

      await appState.bootstrap();
      await appState.loadCatalog();

      final dairyItems = appState.catalog(categoryId: 'c1');
      expect(dairyItems.length, equals(1));
      expect(dairyItems.first.name, equals('Fresh Organic Milk'));

      final searchItems = appState.catalog(searchQuery: 'bread');
      expect(searchItems.length, equals(1));
      expect(searchItems.first.name, equals('Whole Wheat Bread'));
    });
  });
}
