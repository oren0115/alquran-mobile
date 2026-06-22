import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/shalat.dart';
import '../services/service_locator.dart';
import '../services/settings_service.dart';
import '../services/shalat_service.dart';
import 'shalat_state.dart';

class ShalatCubit extends Cubit<ShalatState> {
  ShalatCubit({
    ShalatService? shalatService,
    SettingsService? settingsService,
  })  : _shalatService =
            shalatService ?? ServiceLocator.instance.shalatService,
        _settingsService =
            settingsService ?? ServiceLocator.instance.settingsService,
        super(const ShalatState());

  final ShalatService _shalatService;
  final SettingsService _settingsService;

  Future<void> loadJadwal() async {
    emit(state.copyWith(status: ShalatStatus.loading, clearError: true));
    try {
      final now = DateTime.now();
      final jadwal = await _shalatService.getJadwal(
        provinsi: _settingsService.provinsi,
        kabkota: _settingsService.kabkota,
        bulan: now.month,
        tahun: now.year,
      );
      _emitJadwal(jadwal);
    } catch (e) {
      emit(
        state.copyWith(
          status: ShalatStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() => loadJadwal();

  void updateNextPrayer() {
    final jadwal = state.jadwal;
    if (jadwal == null) return;

    final now = DateTime.now();
    final today = jadwal.jadwalHariIni(now);
    if (today == null) return;

    final next = ShalatHelper.hitungBerikutnya(
      today,
      jadwal.jadwalBesok(now),
      now,
    );
    emit(state.copyWith(today: today, nextPrayer: next));
  }

  Future<void> loadProvinsi() async {
    if (state.provinsiList.isNotEmpty) return;
    try {
      final list = await _shalatService.getProvinsi();
      emit(state.copyWith(provinsiList: list));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> loadKabkota(String provinsi) async {
    emit(state.copyWith(loadingKabkota: true, kabkotaList: []));
    try {
      final list = await _shalatService.getKabkota(provinsi);
      emit(state.copyWith(kabkotaList: list, loadingKabkota: false));
    } catch (e) {
      emit(
        state.copyWith(
          loadingKabkota: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _emitJadwal(ShalatBulanan jadwal) {
    final now = DateTime.now();
    final today = jadwal.jadwalHariIni(now);
    final next = today != null
        ? ShalatHelper.hitungBerikutnya(
            today,
            jadwal.jadwalBesok(now),
            now,
          )
        : null;

    emit(
      state.copyWith(
        status: ShalatStatus.loaded,
        jadwal: jadwal,
        today: today,
        nextPrayer: next,
      ),
    );
  }
}
