import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/audio_cubit.dart';
import 'cubit/bookmark_cubit.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/surah_cubit.dart';
import 'pages/routes/app_routes.dart';
import 'pages/theme/app_text.dart';
import 'pages/theme/app_theme.dart';
import 'services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.instance.init();

  runApp(const AlQuranApp());
}

class AlQuranApp extends StatelessWidget {
  const AlQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SurahCubit()..loadSurah()),
        BlocProvider(create: (_) => BookmarkCubit()..loadBookmarks()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => AudioCubit()),
      ],
      child: MaterialApp(
        title: AppText.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
