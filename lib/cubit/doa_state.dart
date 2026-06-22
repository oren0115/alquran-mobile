import 'package:equatable/equatable.dart';

import '../models/doa.dart';

enum DoaStatus { initial, loading, loaded, error }

class DoaState extends Equatable {
  const DoaState({
    this.status = DoaStatus.initial,
    this.allDoa = const [],
    this.filteredList = const [],
    this.grups = const [],
    this.tags = const [],
    this.searchQuery = '',
    this.selectedGrup,
    this.selectedTag,
    this.errorMessage,
  });

  final DoaStatus status;
  final List<Doa> allDoa;
  final List<Doa> filteredList;
  final List<String> grups;
  final List<String> tags;
  final String searchQuery;
  final String? selectedGrup;
  final String? selectedTag;
  final String? errorMessage;

  DoaState copyWith({
    DoaStatus? status,
    List<Doa>? allDoa,
    List<Doa>? filteredList,
    List<String>? grups,
    List<String>? tags,
    String? searchQuery,
    String? selectedGrup,
    String? selectedTag,
    String? errorMessage,
    bool clearGrup = false,
    bool clearTag = false,
    bool clearError = false,
  }) {
    return DoaState(
      status: status ?? this.status,
      allDoa: allDoa ?? this.allDoa,
      filteredList: filteredList ?? this.filteredList,
      grups: grups ?? this.grups,
      tags: tags ?? this.tags,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedGrup: clearGrup ? null : (selectedGrup ?? this.selectedGrup),
      selectedTag: clearTag ? null : (selectedTag ?? this.selectedTag),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        allDoa,
        filteredList,
        grups,
        tags,
        searchQuery,
        selectedGrup,
        selectedTag,
        errorMessage,
      ];
}

List<Doa> applyDoaFilters({
  required List<Doa> list,
  String query = '',
  String? grup,
  String? tag,
}) {
  var result = list;

  if (grup != null && grup.isNotEmpty) {
    result = result.where((d) => d.grup == grup).toList();
  }

  if (tag != null && tag.isNotEmpty) {
    result = result.where((d) => d.tags.contains(tag)).toList();
  }

  final q = query.trim().toLowerCase();
  if (q.isNotEmpty) {
    result = result.where((d) {
      return d.nama.toLowerCase().contains(q) ||
          d.idn.toLowerCase().contains(q) ||
          d.grup.toLowerCase().contains(q) ||
          d.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  return result;
}

List<String> extractGrups(List<Doa> list) {
  final set = <String>{};
  for (final doa in list) {
    set.add(doa.grup);
  }
  final sorted = set.toList()..sort();
  return sorted;
}

List<String> extractTags(List<Doa> list) {
  final set = <String>{};
  for (final doa in list) {
    set.addAll(doa.tags);
  }
  final sorted = set.toList()..sort();
  return sorted;
}
