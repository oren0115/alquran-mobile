import 'package:equatable/equatable.dart';

import '../services/settings_service.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.qari = '01',
    this.lastReadSurah,
    this.lastReadAyat,
    this.provinsi = defaultProvinsi,
    this.kabkota = defaultKabkota,
  });

  final String qari;
  final int? lastReadSurah;
  final int? lastReadAyat;
  final String provinsi;
  final String kabkota;

  SettingsState copyWith({
    String? qari,
    int? lastReadSurah,
    int? lastReadAyat,
    String? provinsi,
    String? kabkota,
  }) {
    return SettingsState(
      qari: qari ?? this.qari,
      lastReadSurah: lastReadSurah ?? this.lastReadSurah,
      lastReadAyat: lastReadAyat ?? this.lastReadAyat,
      provinsi: provinsi ?? this.provinsi,
      kabkota: kabkota ?? this.kabkota,
    );
  }

  @override
  List<Object?> get props =>
      [qari, lastReadSurah, lastReadAyat, provinsi, kabkota];
}
