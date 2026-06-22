import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';
import 'bookmark_service.dart';
import 'dio_client.dart';
import 'doa_service.dart';
import 'quran_service.dart';
import 'settings_service.dart';
import 'shalat_service.dart';

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  late final QuranService quranService;
  late final BookmarkService bookmarkService;
  late final SettingsService settingsService;
  late final ShalatService shalatService;
  late final DoaService doaService;

  Future<void> init() async {
    await Hive.initFlutter();
    final bookmarkBox = await Hive.openBox(BookmarkService.boxName);
    final prefs = await SharedPreferences.getInstance();

    final dioClient = DioClient();
    final apiService = ApiService(dioClient);

    quranService = QuranService(apiService);
    bookmarkService = BookmarkService(bookmarkBox);
    settingsService = SettingsService(prefs);
    shalatService = ShalatService(apiService);
    doaService = DoaService();
  }
}
