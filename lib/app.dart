import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'core/theme/neumorphic_theme.dart';
import 'state/app_state.dart';

class SaudaListApp extends StatelessWidget {
  const SaudaListApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'SaudaList',
      debugShowCheckedModeBanner: false,
      themeMode: appState.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: NeumorphicColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: NeumorphicColors.accentGreen,
          primary: NeumorphicColors.accentGreen,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: NeumorphicColors.accentGreen,
          brightness: Brightness.dark,
          primary: NeumorphicColors.accentGreen,
        ),
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
