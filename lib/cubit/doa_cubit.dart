import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/doa.dart';
import '../services/doa_service.dart';
import '../services/service_locator.dart';
import 'doa_state.dart';

class DoaCubit extends Cubit<DoaState> {
  DoaCubit({DoaService? doaService})
      : _doaService = doaService ?? ServiceLocator.instance.doaService,
        super(const DoaState());

  final DoaService _doaService;

  Future<void> loadDoa() async {
    if (state.status == DoaStatus.loaded) return;
    emit(state.copyWith(status: DoaStatus.loading, clearError: true));
    try {
      final list = await _doaService.getAllDoa();
      _emitLoaded(list);
    } catch (e) {
      emit(state.copyWith(status: DoaStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: DoaStatus.loading, clearError: true));
    try {
      final list = await _doaService.getAllDoa();
      _emitLoaded(list);
    } catch (e) {
      emit(state.copyWith(status: DoaStatus.error, errorMessage: e.toString()));
    }
  }

  Doa? findById(int id) {
    for (final doa in state.allDoa) {
      if (doa.id == id) return doa;
    }
    return null;
  }

  Future<Doa> getDetail(int id) async {
    final cached = findById(id);
    if (cached != null) return cached;
    return _doaService.getDoaById(id);
  }

  void setSearchQuery(String query) {
    emit(
      state.copyWith(
        searchQuery: query,
        filteredList: applyDoaFilters(
          list: state.allDoa,
          query: query,
          grup: state.selectedGrup,
          tag: state.selectedTag,
        ),
      ),
    );
  }

  void setGrup(String? grup) {
    final selected = grup == state.selectedGrup ? null : grup;
    emit(
      state.copyWith(
        selectedGrup: selected,
        clearGrup: selected == null,
        filteredList: applyDoaFilters(
          list: state.allDoa,
          query: state.searchQuery,
          grup: selected,
          tag: state.selectedTag,
        ),
      ),
    );
  }

  void setTag(String? tag) {
    final selected = tag == state.selectedTag ? null : tag;
    emit(
      state.copyWith(
        selectedTag: selected,
        clearTag: selected == null,
        filteredList: applyDoaFilters(
          list: state.allDoa,
          query: state.searchQuery,
          grup: state.selectedGrup,
          tag: selected,
        ),
      ),
    );
  }

  void clearFilters() {
    emit(
      state.copyWith(
        clearGrup: true,
        clearTag: true,
        searchQuery: '',
        filteredList: state.allDoa,
      ),
    );
  }

  void _emitLoaded(List<Doa> list) {
    emit(
      state.copyWith(
        status: DoaStatus.loaded,
        allDoa: list,
        filteredList: applyDoaFilters(
          list: list,
          query: state.searchQuery,
          grup: state.selectedGrup,
          tag: state.selectedTag,
        ),
        grups: extractGrups(list),
        tags: extractTags(list),
      ),
    );
  }
}
