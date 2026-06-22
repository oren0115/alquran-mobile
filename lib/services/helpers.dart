import 'package:dio/dio.dart';

class Helpers {
  Helpers._();

  static String extractErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Koneksi timeout. Periksa jaringan Anda.';
        case DioExceptionType.connectionError:
          return 'Tidak dapat terhubung ke server.';
        case DioExceptionType.badResponse:
          final status = error.response?.statusCode;
          return 'Server error${status != null ? ' ($status)' : ''}.';
        default:
          return error.message ?? 'Terjadi kesalahan jaringan.';
      }
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  static String bookmarkKey({
    required int nomorSurah,
    required int nomorAyat,
  }) {
    return '${nomorSurah}_$nomorAyat';
  }
}
