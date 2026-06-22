import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.qari = '01',
    this.lastReadSurah,
    this.lastReadAyat,
  });

  final String qari;
  final int? lastReadSurah;
  final int? lastReadAyat;

  SettingsState copyWith({
    String? qari,
    int? lastReadSurah,
    int? lastReadAyat,
  }) {
    return SettingsState(
      qari: qari ?? this.qari,
      lastReadSurah: lastReadSurah ?? this.lastReadSurah,
      lastReadAyat: lastReadAyat ?? this.lastReadAyat,
    );
  }

  @override
  List<Object?> get props => [qari, lastReadSurah, lastReadAyat];
}
