import 'package:dio/dio.dart';

import 'api_constants.dart';
import 'dio_client.dart';

class ApiService {
  ApiService(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
  }) {
    return _dio.post<T>(path, data: data);
  }

  Future<List<dynamic>> getList(String path) async {
    final response = await get<Map<String, dynamic>>(path);
    final data = response.data;
    if (data == null) throw Exception('Response kosong');

    final code = data['code'] as int?;
    if (code != null && code != 200) {
      throw Exception(data['message']?.toString() ?? ApiConstants.baseUrl);
    }

    final list = data['data'];
    if (list is! List) throw Exception('Format data tidak valid');
    return list;
  }

  Future<Map<String, dynamic>> getMap(String path) async {
    final response = await get<Map<String, dynamic>>(path);
    final data = response.data;
    if (data == null) throw Exception('Response kosong');

    final code = data['code'] as int?;
    if (code != null && code != 200) {
      throw Exception(data['message']?.toString() ?? 'Gagal memuat data');
    }

    final payload = data['data'];
    if (payload is! Map<String, dynamic>) {
      throw Exception('Format data tidak valid');
    }
    return payload;
  }

  Future<List<dynamic>> postList(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await post<Map<String, dynamic>>(path, data: body);
    final data = response.data;
    if (data == null) throw Exception('Response kosong');

    final code = data['code'] as int?;
    if (code != null && code != 200) {
      throw Exception(data['message']?.toString() ?? 'Gagal memuat data');
    }

    final list = data['data'];
    if (list is! List) throw Exception('Format data tidak valid');
    return list;
  }

  Future<Map<String, dynamic>> postMap(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await post<Map<String, dynamic>>(path, data: body);
    final data = response.data;
    if (data == null) throw Exception('Response kosong');

    final code = data['code'] as int?;
    if (code != null && code != 200) {
      throw Exception(data['message']?.toString() ?? 'Gagal memuat data');
    }

    final payload = data['data'];
    if (payload is! Map<String, dynamic>) {
      throw Exception('Format data tidak valid');
    }
    return payload;
  }
}
