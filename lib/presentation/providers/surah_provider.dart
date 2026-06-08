import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/juz_helper.dart';
import '../../domain/entities/surah_entity.dart';
import '../../injection/dependency_injection.dart';

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final surahListProvider =
    AsyncNotifierProvider<SurahListNotifier, List<SurahEntity>>(
  SurahListNotifier.new,
);

class SurahListNotifier extends AsyncNotifier<List<SurahEntity>> {
  @override
  Future<List<SurahEntity>> build() async {
    final getAllSurah = ref.watch(getAllSurahProvider);
    return getAllSurah.execute();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final getAllSurah = ref.read(getAllSurahProvider);
      return getAllSurah.execute();
    });
  }
}

enum SurahFilter { all, juz, makkiyah, madaniyah }

final surahFilterProvider =
    StateProvider<SurahFilter>((ref) => SurahFilter.all);

final selectedJuzProvider = StateProvider<int?>((ref) => null);

final filteredSurahProvider = Provider<AsyncValue<List<SurahEntity>>>((ref) {
  final asyncList = ref.watch(surahListProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final filter = ref.watch(surahFilterProvider);
  final selectedJuz = ref.watch(selectedJuzProvider);

  return asyncList.whenData((list) {
    var result = list;

    switch (filter) {
      case SurahFilter.makkiyah:
        result = result
            .where((s) => s.tempatTurun.toLowerCase() == 'mekah')
            .toList();
      case SurahFilter.madaniyah:
        result = result
            .where((s) => s.tempatTurun.toLowerCase() == 'madinah')
            .toList();
      case SurahFilter.juz:
        if (selectedJuz != null) {
          result = result
              .where((s) => JuzHelper.surahInJuz(s.nomor, selectedJuz))
              .toList();
        }
      case SurahFilter.all:
        break;
    }

    if (query.isEmpty) return result;
    return result.where((s) {
      return s.namaLatin.toLowerCase().contains(query) ||
          s.arti.toLowerCase().contains(query) ||
          s.nama.contains(query) ||
          s.nomor.toString() == query;
    }).toList();
  });
});
