class ArabicNumerals {
  ArabicNumerals._();

  static const _digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  static String fromInt(int number) {
    return number.toString().split('').map((d) => _digits[int.parse(d)]).join();
  }
}
