import 'package:intl/intl.dart';

class Formatter {
  Formatter._();

  static String formatAyahNumber(int number) {
    return NumberFormat.decimalPattern('id').format(number);
  }

  static String surahSubtitle({
    required String tempatTurun,
    required int jumlahAyat,
  }) {
    return '$tempatTurun • $jumlahAyat ayat';
  }
}
