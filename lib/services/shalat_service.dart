import '../models/shalat.dart';
import 'api_constants.dart';
import 'api_service.dart';

class ShalatService {
  ShalatService(this._apiService);

  final ApiService _apiService;

  Future<List<String>> getProvinsi() async {
    final list = await _apiService.getList(ApiConstants.shalatProvinsi);
    return list.map((e) => e.toString()).toList();
  }

  Future<List<String>> getKabkota(String provinsi) async {
    final list = await _apiService.postList(
      ApiConstants.shalatKabkota,
      body: {'provinsi': provinsi},
    );
    return list.map((e) => e.toString()).toList();
  }

  Future<ShalatBulanan> getJadwal({
    required String provinsi,
    required String kabkota,
    int? bulan,
    int? tahun,
  }) async {
    final body = <String, dynamic>{
      'provinsi': provinsi,
      'kabkota': kabkota,
    };
    if (bulan != null) body['bulan'] = bulan;
    if (tahun != null) body['tahun'] = tahun;

    final data = await _apiService.postMap(ApiConstants.shalat, body: body);
    return ShalatBulanan.fromJson(data);
  }
}
