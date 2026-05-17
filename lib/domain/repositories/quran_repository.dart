import '../entities/surah_entity.dart';

abstract class QuranRepository {
  Future<List<SurahEntity>> getAllSurah();
  Future<DetailSurahEntity> getDetailSurah(int nomor);
  Future<TafsirEntity> getTafsir(int nomor);
}
