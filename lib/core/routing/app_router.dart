import 'package:flutter/material.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/saved_lists/my_lists_screen.dart';
import '../../features/saved_lists/list_details_screen.dart';
import '../../features/pdf_preview/pdf_preview_screen.dart';
import '../../features/settings/profile_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/user_management_screen.dart';
import '../../features/admin/analytics_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String products = '/products';
  static const String myLists = '/my-lists';
  static const String listDetails = '/list-details';
  static const String pdfPreview = '/pdf-preview';
  static const String profile = '/profile';
  static const String admin = '/admin';
  static const String userManagement = '/admin/users';
  static const String analytics = '/admin/analytics';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case products:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProductsScreen(
            categoryId: args?['categoryId'] as String?,
            searchQuery: args?['searchQuery'] as String?,
          ),
        );
      case myLists:
        return MaterialPageRoute(builder: (_) => const MyListsScreen());
      case listDetails:
        return MaterialPageRoute(
          builder: (_) => ListDetailsScreen(listId: settings.arguments as String?),
        );
      case pdfPreview:
        return MaterialPageRoute(
          builder: (_) => PdfPreviewScreen(listId: settings.arguments as String?),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case admin:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case userManagement:
        return MaterialPageRoute(builder: (_) => const UserManagementScreen());
      case analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
