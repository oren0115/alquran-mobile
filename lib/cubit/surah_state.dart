import 'package:equatable/equatable.dart';

import '../models/surah.dart';
import '../services/juz_helper.dart';

enum SurahFilter { all, juz, makkiyah, madaniyah }

enum SurahStatus { initial, loading, loaded, error }

class SurahState extends Equatable {
  const SurahState({
    this.status = SurahStatus.initial,
    this.surahList = const [],
    this.filteredList = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.filter = SurahFilter.all,
    this.selectedJuz,
  });

  final SurahStatus status;
  final List<Surah> surahList;
  final List<Surah> filteredList;
  final String? errorMessage;
  final String searchQuery;
  final SurahFilter filter;
  final int? selectedJuz;

  SurahState copyWith({
    SurahStatus? status,
    List<Surah>? surahList,
    List<Surah>? filteredList,
    String? errorMessage,
    String? searchQuery,
    SurahFilter? filter,
    int? selectedJuz,
    bool clearSelectedJuz = false,
    bool clearError = false,
  }) {
    return SurahState(
      status: status ?? this.status,
      surahList: surahList ?? this.surahList,
      filteredList: filteredList ?? this.filteredList,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      selectedJuz:
          clearSelectedJuz ? null : (selectedJuz ?? this.selectedJuz),
    );
  }

  @override
  List<Object?> get props => [
        status,
        surahList,
        filteredList,
        errorMessage,
        searchQuery,
        filter,
        selectedJuz,
      ];
}

List<Surah> applySurahFilters({
  required List<Surah> list,
  required String query,
  required SurahFilter filter,
  required int? selectedJuz,
}) {
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

  final q = query.trim().toLowerCase();
  if (q.isEmpty) return result;

  return result.where((s) {
    return s.namaLatin.toLowerCase().contains(q) ||
        s.arti.toLowerCase().contains(q) ||
        s.nama.contains(q) ||
        s.nomor.toString() == q;
  }).toList();
}
