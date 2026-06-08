import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ayat_entity.dart';
import '../../injection/dependency_injection.dart';

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

  Future<bool> toggleBookmark(AyatEntity ayat) async {
    final ds = ref.read(bookmarkLocalDataSourceProvider);
    if (ayat.nomorSurah == null || ayat.namaSurahLatin == null) {
      throw Exception('Data surah ayat tidak lengkap');
    }

    final surah = ayat.nomorSurah!;
    final exists = await ds.isBookmarked(surah, ayat.nomorAyat);

    if (exists) {
      await ds.removeBookmark(surah, ayat.nomorAyat);
    } else {
      await ds.addBookmark(ayat);
    }

    ref.invalidate(isBookmarkedProvider((surah: surah, ayat: ayat.nomorAyat)));
    await refresh();
    return !exists;
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
    this.qari = '01',
    this.lastReadSurah,
    this.lastReadAyat,
  });

  final String qari;
  final int? lastReadSurah;
  final int? lastReadAyat;

  SettingsState copyWith({
    String? qari,
    int? lastReadSurah,
    int? lastReadAyat,
  }) {
    return SettingsState(
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
      qari: prefs.getString(prefQari) ?? '01',
      lastReadSurah: prefs.getInt(prefLastReadSurah),
      lastReadAyat: prefs.getInt(prefLastReadAyat),
    );
  }

  Future<void> setQari(String value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(prefQari, value);
    state = state.copyWith(qari: value);
  }

  Future<void> saveLastRead(int surah, int ayat) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(prefLastReadSurah, surah);
    await prefs.setInt(prefLastReadAyat, ayat);
    state = state.copyWith(lastReadSurah: surah, lastReadAyat: ayat);
  }
}
