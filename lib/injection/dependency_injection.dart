import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_service.dart';
import '../core/network/dio_client.dart';
import '../data/datasource/local/bookmark_local_datasource.dart';
import '../data/datasource/remote/quran_remote_datasource.dart';
import '../data/repositories/quran_repository_impl.dart';
import '../domain/repositories/quran_repository.dart';
import '../domain/usecases/get_all_surah.dart';
import '../domain/usecases/get_detail_surah.dart';
import '../domain/usecases/get_tafsir.dart';

// --- Core ---
final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(ref.watch(dioClientProvider)),
);

// --- Local storage ---
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences belum diinisialisasi');
});

final bookmarkBoxProvider = Provider<Box<dynamic>>((ref) {
  throw UnimplementedError('Hive box belum diinisialisasi');
});

// --- Data sources ---
final quranRemoteDataSourceProvider = Provider<QuranRemoteDataSource>(
  (ref) => QuranRemoteDataSourceImpl(ref.watch(apiServiceProvider)),
);

final bookmarkLocalDataSourceProvider = Provider<BookmarkLocalDataSource>(
  (ref) => BookmarkLocalDataSourceImpl(ref.watch(bookmarkBoxProvider)),
);

// --- Repository ---
final quranRepositoryProvider = Provider<QuranRepository>(
  (ref) => QuranRepositoryImpl(ref.watch(quranRemoteDataSourceProvider)),
);

// --- Use cases ---
final getAllSurahProvider = Provider<GetAllSurah>(
  (ref) => GetAllSurah(ref.watch(quranRepositoryProvider)),
);

final getDetailSurahProvider = Provider<GetDetailSurah>(
  (ref) => GetDetailSurah(ref.watch(quranRepositoryProvider)),
);

final getTafsirProvider = Provider<GetTafsir>(
  (ref) => GetTafsir(ref.watch(quranRepositoryProvider)),
);

// --- Settings keys ---
const String prefQari = 'qari';
const String prefLastReadSurah = 'last_read_surah';
const String prefLastReadAyat = 'last_read_ayat';

/// Inisialisasi Hive & SharedPreferences sebelum runApp.
Future<ProviderContainer> initDependencies() async {
  await Hive.initFlutter();
  final bookmarkBox = await Hive.openBox(BookmarkLocalDataSourceImpl.boxName);
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      bookmarkBoxProvider.overrideWithValue(bookmarkBox),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  return container;
}
