import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_text.dart';
import 'core/constants/app_theme.dart';
import 'injection/dependency_injection.dart';
import 'presentation/providers/bookmark_provider.dart';
import 'presentation/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = await initDependencies();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AlQuranApp(),
    ),
  );
}

class AlQuranApp extends ConsumerWidget {
  const AlQuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: AppText.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
