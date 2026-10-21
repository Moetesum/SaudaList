import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/theme/neumorphic_theme.dart';

class SaudaListApp extends StatelessWidget {
  const SaudaListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaudaList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: NeumorphicColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: NeumorphicColors.accentGreen,
          primary: NeumorphicColors.accentGreen,
        ),
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
