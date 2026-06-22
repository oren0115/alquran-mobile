import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/detail_surah_cubit.dart';
import '../../cubit/tafsir_cubit.dart';
import '../bookmark/bookmark_page.dart';
import '../detail_surah/detail_surah_page.dart';
import '../doa/doa_detail_page.dart';
import '../doa/doa_page.dart';
import '../home/home_page.dart';
import '../murottal/murottal_page.dart';
import '../settings/settings_page.dart';
import '../shalat/shalat_page.dart';
import '../splash/splash_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String detailSurah = '/detail-surah';
  static const String bookmark = '/bookmark';
  static const String murottal = '/murottal';
  static const String settings = '/settings';
  static const String shalat = '/shalat';
  static const String doa = '/doa';
  static const String doaDetail = '/doa-detail';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case detailSurah:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        final nomor = args?['nomor'] as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => DetailSurahCubit(nomor)..loadDetail(),
              ),
              BlocProvider(create: (_) => TafsirCubit(nomor)),
            ],
            child: DetailSurahPage(nomorSurah: nomor),
          ),
        );
      case bookmark:
        return MaterialPageRoute(builder: (_) => const BookmarkPage());
      case murottal:
        final murottalArgs = routeSettings.arguments as Map<String, dynamic>?;
        final murottalNomor = murottalArgs?['nomor'] as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DetailSurahCubit(murottalNomor)..loadDetail(),
            child: MurottalPage(nomorSurah: murottalNomor),
          ),
        );
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case shalat:
        return MaterialPageRoute(builder: (_) => const ShalatPage());
      case doa:
        return MaterialPageRoute(builder: (_) => const DoaPage());
      case doaDetail:
        final doaArgs = routeSettings.arguments as Map<String, dynamic>?;
        final doaId = doaArgs?['id'] as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => DoaDetailPage(doaId: doaId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route tidak ditemukan: ${routeSettings.name}'),
            ),
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

  static void goToMurottal(BuildContext context, int nomor) {
    Navigator.pushNamed(
      context,
      murottal,
      arguments: {'nomor': nomor},
    );
  }

  static void goToDoa(BuildContext context) {
    Navigator.pushNamed(context, doa);
  }

  static void goToDoaDetail(BuildContext context, int id) {
    Navigator.pushNamed(
      context,
      doaDetail,
      arguments: {'id': id},
    );
  }
}
