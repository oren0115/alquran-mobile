import '../entities/surah_entity.dart';
import '../repositories/quran_repository.dart';

class GetAllSurah {
  const GetAllSurah(this._repository);

  final QuranRepository _repository;

  Future<List<SurahEntity>> execute() => _repository.getAllSurah();
}
