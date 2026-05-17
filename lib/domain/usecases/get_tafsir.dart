import '../entities/surah_entity.dart';
import '../repositories/quran_repository.dart';

class GetTafsir {
  const GetTafsir(this._repository);

  final QuranRepository _repository;

  Future<TafsirEntity> execute(int nomor) => _repository.getTafsir(nomor);
}
