import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../../models/detail_surah_model.dart';
import '../../models/surah_model.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> getAllSurah();
  Future<DetailSurahModel> getDetailSurah(int nomor);
  Future<TafsirModel> getTafsir(int nomor);
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  QuranRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<SurahModel>> getAllSurah() async {
    final list = await _apiService.getList(ApiConstants.surat);
    return list
        .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DetailSurahModel> getDetailSurah(int nomor) async {
    final data = await _apiService.getMap(ApiConstants.suratDetail(nomor));
    return DetailSurahModel.fromJson(data);
  }

  @override
  Future<TafsirModel> getTafsir(int nomor) async {
    final data = await _apiService.getMap(ApiConstants.tafsir(nomor));
    return TafsirModel.fromJson(data);
  }
}
