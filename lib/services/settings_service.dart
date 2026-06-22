import 'package:shared_preferences/shared_preferences.dart';

const String prefQari = 'qari';
const String prefLastReadSurah = 'last_read_surah';
const String prefLastReadAyat = 'last_read_ayat';
const String prefProvinsi = 'shalat_provinsi';
const String prefKabkota = 'shalat_kabkota';

const String defaultProvinsi = 'Jawa Barat';
const String defaultKabkota = 'Kota Bogor';

/// Key qari EQuran: 01-06
const Map<String, String> qariLabels = {
  '01': 'Abdullah Al-Juhany',
  '02': 'Abdul Muhsin Al-Qasim',
  '03': 'Abdurrahman As-Sudais',
  '04': 'Ibrahim Al-Dossari',
  '05': 'Misyari Rasyid Al-Afasy',
  '06': 'Yasser Al-Dosari',
};

class SettingsService {
  SettingsService(this._prefs);

  final SharedPreferences _prefs;

  String get qari => _prefs.getString(prefQari) ?? '01';
  int? get lastReadSurah => _prefs.getInt(prefLastReadSurah);
  int? get lastReadAyat => _prefs.getInt(prefLastReadAyat);
  String get provinsi => _prefs.getString(prefProvinsi) ?? defaultProvinsi;
  String get kabkota => _prefs.getString(prefKabkota) ?? defaultKabkota;

  Future<void> setQari(String value) async {
    await _prefs.setString(prefQari, value);
  }

  Future<void> saveLastRead(int surah, int ayat) async {
    await _prefs.setInt(prefLastReadSurah, surah);
    await _prefs.setInt(prefLastReadAyat, ayat);
  }

  Future<void> setLocation(String provinsi, String kabkota) async {
    await _prefs.setString(prefProvinsi, provinsi);
    await _prefs.setString(prefKabkota, kabkota);
  }
}
