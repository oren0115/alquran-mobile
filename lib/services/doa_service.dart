import 'package:dio/dio.dart';

import '../models/doa.dart';
import 'api_constants.dart';

class DoaService {
  DoaService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.doaBaseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

  final Dio _dio;

  Future<List<Doa>> getAllDoa({String? grup, String? tag}) async {
    final query = <String, dynamic>{};
    if (grup != null && grup.isNotEmpty) query['grup'] = grup;
    if (tag != null && tag.isNotEmpty) query['tag'] = tag;

    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.doa,
      queryParameters: query.isEmpty ? null : query,
    );
    return _parseList(response.data);
  }

  Future<Doa> getDoaById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.doaDetail(id),
    );
    final data = response.data;
    if (data == null) throw Exception('Response kosong');

    if (data['status'] != 'success') {
      throw Exception('Gagal memuat doa');
    }

    final payload = data['data'];
    if (payload is! Map<String, dynamic>) {
      throw Exception('Format data tidak valid');
    }
    return Doa.fromJson(payload);
  }

  List<Doa> _parseList(Map<String, dynamic>? data) {
    if (data == null) throw Exception('Response kosong');
    if (data['status'] != 'success') {
      throw Exception('Gagal memuat doa');
    }

    final list = data['data'];
    if (list is! List) throw Exception('Format data tidak valid');

    return list
        .map((e) => Doa.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
