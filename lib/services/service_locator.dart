import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';
import 'bookmark_service.dart';
import 'dio_client.dart';
import 'quran_service.dart';
import 'settings_service.dart';

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  late final QuranService quranService;
  late final BookmarkService bookmarkService;
  late final SettingsService settingsService;

  Future<void> init() async {
    await Hive.initFlutter();
    final bookmarkBox = await Hive.openBox(BookmarkService.boxName);
    final prefs = await SharedPreferences.getInstance();

    final dioClient = DioClient();
    final apiService = ApiService(dioClient);

    quranService = QuranService(apiService);
    bookmarkService = BookmarkService(bookmarkBox);
    settingsService = SettingsService(prefs);
  }
}
