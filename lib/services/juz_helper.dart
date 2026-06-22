/// Pemetaan surah ke juz berdasarkan nomor surah awal tiap juz.
class JuzHelper {
  JuzHelper._();

  static const List<int> _juzStartSurah = [
    1, 2, 2, 2, 3, 4, 4, 5, 6, 7,
    8, 9, 11, 12, 15, 17, 18, 21, 23, 25,
    27, 29, 33, 36, 39, 41, 46, 51, 58, 67,
  ];

  static int juzForSurah(int nomorSurah) {
    if (nomorSurah < 1 || nomorSurah > 114) return 1;
    for (var juz = 30; juz >= 1; juz--) {
      if (nomorSurah >= _juzStartSurah[juz - 1]) return juz;
    }
    return 1;
  }

  static bool surahInJuz(int nomorSurah, int juz) {
    if (juz < 1 || juz > 30) return false;
    final start = _juzStartSurah[juz - 1];
    final end = juz < 30 ? _juzStartSurah[juz] - 1 : 114;
    return nomorSurah >= start && nomorSurah <= end;
  }
}
