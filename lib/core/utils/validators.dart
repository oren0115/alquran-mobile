class Validators {
  Validators._();

  static bool isValidSurahNumber(int? nomor) {
    return nomor != null && nomor >= 1 && nomor <= 114;
  }

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
