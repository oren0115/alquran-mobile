import '../models/surah.dart';
import 'api_constants.dart';
import 'api_service.dart';

class QuranService {
  QuranService(this._apiService);

  final ApiService _apiService;

  Future<List<Surah>> getAllSurah() async {
    final list = await _apiService.getList(ApiConstants.surat);
    return list
        .map((e) => Surah.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DetailSurah> getDetailSurah(int nomor) async {
    final data = await _apiService.getMap(ApiConstants.suratDetail(nomor));
    return DetailSurah.fromJson(data);
  }

  Future<Tafsir> getTafsir(int nomor) async {
    final data = await _apiService.getMap(ApiConstants.tafsir(nomor));
    return Tafsir.fromJson(data);
  }
}
