class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://equran.id/api/v2';

  static const String surat = '/surat';
  static String suratDetail(int nomor) => '/surat/$nomor';
  static String tafsir(int nomor) => '/tafsir/$nomor';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
