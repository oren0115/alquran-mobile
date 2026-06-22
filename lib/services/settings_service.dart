import 'package:shared_preferences/shared_preferences.dart';

const String prefQari = 'qari';
const String prefLastReadSurah = 'last_read_surah';
const String prefLastReadAyat = 'last_read_ayat';

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

  Future<void> setQari(String value) async {
    await _prefs.setString(prefQari, value);
  }

  Future<void> saveLastRead(int surah, int ayat) async {
    await _prefs.setInt(prefLastReadSurah, surah);
    await _prefs.setInt(prefLastReadAyat, ayat);
  }
}
