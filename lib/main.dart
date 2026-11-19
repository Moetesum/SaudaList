import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/supabase_service.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    runApp(const _ConfigErrorApp());
    return;
  }

  try {
    await SupabaseService().initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    runApp(_ConfigErrorApp(message: 'Failed to initialize Supabase: $e'));
    return;
  }

  final appState = AppState();
  await appState.bootstrap();

  runApp(
    ChangeNotifierProvider.value(value: appState, child: const SaudaListApp()),
  );
}

class _ConfigErrorApp extends StatelessWidget {
  final String message;
  const _ConfigErrorApp({
    this.message = 'Missing SUPABASE_URL or SUPABASE_ANON_KEY build arguments (--dart-define).',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
