import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/surah_entity.dart';
import '../../injection/dependency_injection.dart';

final detailSurahProvider = AsyncNotifierProvider.family<
    DetailSurahNotifier, DetailSurahEntity, int>(
  DetailSurahNotifier.new,
);

class DetailSurahNotifier extends AsyncNotifier<DetailSurahEntity> {
  DetailSurahNotifier(this.arg);

  final int arg;

  @override
  Future<DetailSurahEntity> build() async {
    final getDetail = ref.watch(getDetailSurahProvider);
    return getDetail.execute(arg);
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

class TafsirNotifier extends AsyncNotifier<TafsirEntity> {
  TafsirNotifier(this.arg);

  final int arg;

  @override
  Future<TafsirEntity> build() async {
    final getTafsir = ref.watch(getTafsirProvider);
    return getTafsir.execute(arg);
  }
}

/// Key qari EQuran: 01-06
const Map<String, String> qariLabels = {
  '01': 'Abdullah Al-Juhany',
  '02': 'Abdul Muhsin Al-Qasim',
  '03': 'Abdurrahman As-Sudais',
  '04': 'Ibrahim Al-Dossari',
  '05': 'Misyari Rasyid Al-Afasy',
  '06': 'Yasser Al-Dosari',
};
