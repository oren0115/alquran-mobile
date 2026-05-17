import 'package:flutter/material.dart';

import '../pages/bookmark/bookmark_page.dart';
import '../pages/detail_surah/detail_surah_page.dart';
import '../pages/home/home_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/splash/splash_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String detailSurah = '/detail-surah';
  static const String bookmark = '/bookmark';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case detailSurah:
        final args = settings.arguments as Map<String, dynamic>?;
        final nomor = args?['nomor'] as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => DetailSurahPage(nomorSurah: nomor),
        );
      case bookmark:
        return MaterialPageRoute(builder: (_) => const BookmarkPage());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route tidak ditemukan: ${settings.name}')),
          ),
        );
    }
  }

  static void goToDetailSurah(BuildContext context, int nomor) {
    Navigator.pushNamed(
      context,
      detailSurah,
      arguments: {'nomor': nomor},
    );
  }
}
