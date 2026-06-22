import 'package:equatable/equatable.dart';

import '../models/shalat.dart';

enum ShalatStatus { initial, loading, loaded, error }

class ShalatState extends Equatable {
  const ShalatState({
    this.status = ShalatStatus.initial,
    this.jadwal,
    this.today,
    this.nextPrayer,
    this.provinsiList = const [],
    this.kabkotaList = const [],
    this.loadingKabkota = false,
    this.errorMessage,
  });

  final ShalatStatus status;
  final ShalatBulanan? jadwal;
  final ShalatHarian? today;
  final NextPrayer? nextPrayer;
  final List<String> provinsiList;
  final List<String> kabkotaList;
  final bool loadingKabkota;
  final String? errorMessage;

  ShalatState copyWith({
    ShalatStatus? status,
    ShalatBulanan? jadwal,
    ShalatHarian? today,
    NextPrayer? nextPrayer,
    List<String>? provinsiList,
    List<String>? kabkotaList,
    bool? loadingKabkota,
    String? errorMessage,
    bool clearError = false,
    bool clearJadwal = false,
  }) {
    return ShalatState(
      status: status ?? this.status,
      jadwal: clearJadwal ? null : (jadwal ?? this.jadwal),
      today: clearJadwal ? null : (today ?? this.today),
      nextPrayer: clearJadwal ? null : (nextPrayer ?? this.nextPrayer),
      provinsiList: provinsiList ?? this.provinsiList,
      kabkotaList: kabkotaList ?? this.kabkotaList,
      loadingKabkota: loadingKabkota ?? this.loadingKabkota,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        jadwal,
        today,
        nextPrayer,
        provinsiList,
        kabkotaList,
        loadingKabkota,
        errorMessage,
      ];
}
