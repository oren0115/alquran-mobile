import 'package:intl/intl.dart';

class Formatter {
  Formatter._();

  static String formatAyahNumber(int number) {
    return NumberFormat.decimalPattern('id').format(number);
  }

  static String displayTempatTurun(String tempatTurun) {
    switch (tempatTurun.toLowerCase()) {
      case 'mekah':
        return 'Makkiyah';
      case 'madinah':
        return 'Madaniyah';
      default:
        return tempatTurun;
    }
  }

  static String surahSubtitle({
    required String tempatTurun,
    required int jumlahAyat,
  }) {
    return '$jumlahAyat ayah · ${displayTempatTurun(tempatTurun)}';
  }
}
