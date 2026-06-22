import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/quran_service.dart';
import '../services/service_locator.dart';
import 'detail_surah_state.dart';

class DetailSurahCubit extends Cubit<DetailSurahState> {
  DetailSurahCubit(this.nomorSurah, {QuranService? quranService})
      : _quranService = quranService ?? ServiceLocator.instance.quranService,
        super(const DetailSurahState());

  final int nomorSurah;
  final QuranService _quranService;

  Future<void> loadDetail() async {
    emit(state.copyWith(status: DetailSurahStatus.loading, clearError: true));
    try {
      final surah = await _quranService.getDetailSurah(nomorSurah);
      emit(
        state.copyWith(status: DetailSurahStatus.loaded, surah: surah),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DetailSurahStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() => loadDetail();
}
