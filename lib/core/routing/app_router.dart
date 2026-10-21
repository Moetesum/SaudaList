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
        return MaterialPageRoute(builder: (_) => const ProductsScreen());
      case myLists:
        return MaterialPageRoute(builder: (_) => const MyListsScreen());
      case listDetails:
        return MaterialPageRoute(builder: (_) => const ListDetailsScreen());
      case pdfPreview:
        return MaterialPageRoute(builder: (_) => const PdfPreviewScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
