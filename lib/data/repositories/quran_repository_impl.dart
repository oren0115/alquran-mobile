import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasource/remote/quran_remote_datasource.dart';

class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl(this._remoteDataSource);

  final QuranRemoteDataSource _remoteDataSource;

  @override
  Future<List<SurahEntity>> getAllSurah() async {
    final models = await _remoteDataSource.getAllSurah();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<DetailSurahEntity> getDetailSurah(int nomor) async {
    final model = await _remoteDataSource.getDetailSurah(nomor);
    return model.toEntity();
  }

  @override
  Future<TafsirEntity> getTafsir(int nomor) async {
    final model = await _remoteDataSource.getTafsir(nomor);
    return model.toEntity();
  }
}
