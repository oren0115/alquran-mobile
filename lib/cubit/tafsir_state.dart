import 'package:equatable/equatable.dart';

import '../models/surah.dart';

enum TafsirStatus { initial, loading, loaded, error }

class TafsirState extends Equatable {
  const TafsirState({
    this.status = TafsirStatus.initial,
    this.tafsir,
    this.errorMessage,
  });

  final TafsirStatus status;
  final Tafsir? tafsir;
  final String? errorMessage;

  TafsirState copyWith({
    TafsirStatus? status,
    Tafsir? tafsir,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TafsirState(
      status: status ?? this.status,
      tafsir: tafsir ?? this.tafsir,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, tafsir, errorMessage];
}
