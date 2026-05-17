import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ayat_entity.dart';
import '../../injection/dependency_injection.dart';
import 'detail_surah_provider.dart';

final bookmarkListProvider =
    AsyncNotifierProvider<BookmarkListNotifier, List<AyatEntity>>(
  BookmarkListNotifier.new,
);

class BookmarkListNotifier extends AsyncNotifier<List<AyatEntity>> {
  @override
  Future<List<AyatEntity>> build() async {
    final ds = ref.watch(bookmarkLocalDataSourceProvider);
    return ds.getBookmarks();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final ds = ref.read(bookmarkLocalDataSourceProvider);
      return ds.getBookmarks();
    });
  }

  Future<void> toggleBookmark(AyatEntity ayat) async {
    final ds = ref.read(bookmarkLocalDataSourceProvider);
    if (ayat.nomorSurah == null) return;

    final exists = await ds.isBookmarked(
      ayat.nomorSurah!,
      ayat.nomorAyat,
    );

    if (exists) {
      await ds.removeBookmark(ayat.nomorSurah!, ayat.nomorAyat);
    } else {
      await ds.addBookmark(ayat);
    }
    await refresh();
  }
}

final isBookmarkedProvider =
    FutureProvider.family<bool, ({int surah, int ayat})>((ref, params) {
  final ds = ref.watch(bookmarkLocalDataSourceProvider);
  return ds.isBookmarked(params.surah, params.ayat);
});

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SettingsState {
  const SettingsState({
    this.isDarkMode = false,
    this.qari = '01',
    this.lastReadSurah,
    this.lastReadAyat,
  });

  final bool isDarkMode;
  final String qari;
  final int? lastReadSurah;
  final int? lastReadAyat;

  SettingsState copyWith({
    bool? isDarkMode,
    String? qari,
    int? lastReadSurah,
    int? lastReadAyat,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      qari: qari ?? this.qari,
      lastReadSurah: lastReadSurah ?? this.lastReadSurah,
      lastReadAyat: lastReadAyat ?? this.lastReadAyat,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SettingsState(
      isDarkMode: prefs.getBool(prefDarkMode) ?? false,
      qari: prefs.getString(prefQari) ?? '01',
      lastReadSurah: prefs.getInt(prefLastReadSurah),
      lastReadAyat: prefs.getInt(prefLastReadAyat),
    );
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(prefDarkMode, value);
    state = state.copyWith(isDarkMode: value);
  }

  Future<void> setQari(String value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(prefQari, value);
    state = state.copyWith(qari: value);
    ref.read(selectedQariProvider.notifier).state = value;
  }

  Future<void> saveLastRead(int surah, int ayat) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(prefLastReadSurah, surah);
    await prefs.setInt(prefLastReadAyat, ayat);
    state = state.copyWith(lastReadSurah: surah, lastReadAyat: ayat);
  }
}
