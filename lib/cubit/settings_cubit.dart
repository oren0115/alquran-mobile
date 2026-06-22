import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/service_locator.dart';
import '../services/settings_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({SettingsService? settingsService})
      : _settingsService =
            settingsService ?? ServiceLocator.instance.settingsService,
        super(
          SettingsState(
            qari: ServiceLocator.instance.settingsService.qari,
            lastReadSurah:
                ServiceLocator.instance.settingsService.lastReadSurah,
            lastReadAyat: ServiceLocator.instance.settingsService.lastReadAyat,
            provinsi: ServiceLocator.instance.settingsService.provinsi,
            kabkota: ServiceLocator.instance.settingsService.kabkota,
          ),
        );

  final SettingsService _settingsService;

  Future<void> setQari(String value) async {
    await _settingsService.setQari(value);
    emit(state.copyWith(qari: value));
  }

  Future<void> saveLastRead(int surah, int ayat) async {
    await _settingsService.saveLastRead(surah, ayat);
    emit(state.copyWith(lastReadSurah: surah, lastReadAyat: ayat));
  }

  Future<void> setLocation(String provinsi, String kabkota) async {
    await _settingsService.setLocation(provinsi, kabkota);
    emit(state.copyWith(provinsi: provinsi, kabkota: kabkota));
  }
}
