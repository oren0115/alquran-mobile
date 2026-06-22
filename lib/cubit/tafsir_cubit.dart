import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/quran_service.dart';
import '../services/service_locator.dart';
import 'tafsir_state.dart';

class TafsirCubit extends Cubit<TafsirState> {
  TafsirCubit(this.nomorSurah, {QuranService? quranService})
      : _quranService = quranService ?? ServiceLocator.instance.quranService,
        super(const TafsirState());

  final int nomorSurah;
  final QuranService _quranService;

  Future<void> loadTafsir() async {
    emit(state.copyWith(status: TafsirStatus.loading, clearError: true));
    try {
      final tafsir = await _quranService.getTafsir(nomorSurah);
      emit(state.copyWith(status: TafsirStatus.loaded, tafsir: tafsir));
    } catch (e) {
      emit(
        state.copyWith(
          status: TafsirStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
