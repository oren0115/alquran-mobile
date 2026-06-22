import 'package:equatable/equatable.dart';

import '../models/surah.dart';

enum DetailSurahStatus { initial, loading, loaded, error }

class DetailSurahState extends Equatable {
  const DetailSurahState({
    this.status = DetailSurahStatus.initial,
    this.surah,
    this.errorMessage,
  });

  final DetailSurahStatus status;
  final DetailSurah? surah;
  final String? errorMessage;

  DetailSurahState copyWith({
    DetailSurahStatus? status,
    DetailSurah? surah,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DetailSurahState(
      status: status ?? this.status,
      surah: surah ?? this.surah,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, surah, errorMessage];
}
