import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/surah_entity.dart';
import '../../injection/dependency_injection.dart';

final detailSurahProvider = AsyncNotifierProvider.family<
    DetailSurahNotifier, DetailSurahEntity, int>(
  DetailSurahNotifier.new,
);

class DetailSurahNotifier extends FamilyAsyncNotifier<DetailSurahEntity, int> {
  @override
  Future<DetailSurahEntity> build(int nomor) async {
    final getDetail = ref.watch(getDetailSurahProvider);
    return getDetail.execute(nomor);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final getDetail = ref.read(getDetailSurahProvider);
      return getDetail.execute(arg);
    });
  }
}

final tafsirProvider =
    AsyncNotifierProvider.family<TafsirNotifier, TafsirEntity, int>(
  TafsirNotifier.new,
);

class TafsirNotifier extends FamilyAsyncNotifier<TafsirEntity, int> {
  @override
  Future<TafsirEntity> build(int nomor) async {
    final getTafsir = ref.watch(getTafsirProvider);
    return getTafsir.execute(nomor);
  }
}

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return player;
});

final selectedQariProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString(prefQari) ?? '01';
});

/// Key qari EQuran: 01-06
const Map<String, String> qariLabels = {
  '01': 'Abdullah Al-Juhany',
  '02': 'Abdul Muhsin Al-Qasim',
  '03': 'Abdurrahman As-Sudais',
  '04': 'Ibrahim Al-Dossari',
  '05': 'Misyari Rasyid Al-Afasy',
  '06': 'Yasser Al-Dosari',
};
