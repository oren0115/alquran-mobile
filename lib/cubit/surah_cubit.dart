import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/quran_service.dart';
import '../services/service_locator.dart';
import 'surah_state.dart';

class SurahCubit extends Cubit<SurahState> {
  SurahCubit({QuranService? quranService})
      : _quranService = quranService ?? ServiceLocator.instance.quranService,
        super(const SurahState());

  final QuranService _quranService;

  Future<void> loadSurah() async {
    if (state.status == SurahStatus.loaded) return;
    emit(state.copyWith(status: SurahStatus.loading, clearError: true));
    try {
      final list = await _quranService.getAllSurah();
      emit(
        state.copyWith(
          status: SurahStatus.loaded,
          surahList: list,
          filteredList: applySurahFilters(
            list: list,
            query: state.searchQuery,
            filter: state.filter,
            selectedJuz: state.selectedJuz,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SurahStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: SurahStatus.loading, clearError: true));
    try {
      final list = await _quranService.getAllSurah();
      emit(
        state.copyWith(
          status: SurahStatus.loaded,
          surahList: list,
          filteredList: applySurahFilters(
            list: list,
            query: state.searchQuery,
            filter: state.filter,
            selectedJuz: state.selectedJuz,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SurahStatus.error, errorMessage: e.toString()));
    }
  }

  void setSearchQuery(String query) {
    emit(
      state.copyWith(
        searchQuery: query,
        filteredList: applySurahFilters(
          list: state.surahList,
          query: query,
          filter: state.filter,
          selectedJuz: state.selectedJuz,
        ),
      ),
    );
  }

  void setFilter(SurahFilter filter) {
    emit(
      state.copyWith(
        filter: filter,
        filteredList: applySurahFilters(
          list: state.surahList,
          query: state.searchQuery,
          filter: filter,
          selectedJuz: state.selectedJuz,
        ),
      ),
    );
  }

  void selectJuz(int? juz) {
    emit(
      state.copyWith(
        selectedJuz: juz,
        clearSelectedJuz: juz == null,
        filteredList: applySurahFilters(
          list: state.surahList,
          query: state.searchQuery,
          filter: state.filter,
          selectedJuz: juz,
        ),
      ),
    );
  }
}
