import '../entities/surah_entity.dart';
import '../repositories/quran_repository.dart';

class GetDetailSurah {
  const GetDetailSurah(this._repository);

  final QuranRepository _repository;

  Future<DetailSurahEntity> execute(int nomor) =>
      _repository.getDetailSurah(nomor);
}
