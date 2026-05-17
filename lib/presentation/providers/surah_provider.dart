import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/surah_entity.dart';
import '../../injection/dependency_injection.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

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

final filteredSurahProvider = Provider<AsyncValue<List<SurahEntity>>>((ref) {
  final asyncList = ref.watch(surahListProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  return asyncList.whenData((list) {
    if (query.isEmpty) return list;
    return list.where((s) {
      return s.namaLatin.toLowerCase().contains(query) ||
          s.arti.toLowerCase().contains(query) ||
          s.nama.contains(query) ||
          s.nomor.toString() == query;
    }).toList();
  });
});
