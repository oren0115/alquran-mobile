import 'package:hive/hive.dart';

import '../../../core/utils/helpers.dart';
import '../../../domain/entities/ayat_entity.dart';
import '../../models/ayat_model.dart';

abstract class BookmarkLocalDataSource {
  Future<List<AyatEntity>> getBookmarks();
  Future<void> addBookmark(AyatEntity ayat);
  Future<void> removeBookmark(int nomorSurah, int nomorAyat);
  Future<bool> isBookmarked(int nomorSurah, int nomorAyat);
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  BookmarkLocalDataSourceImpl(this._box);

  static const String boxName = 'bookmarks';

  final Box<dynamic> _box;

  @override
  Future<List<AyatEntity>> getBookmarks() async {
    final bookmarks = <AyatEntity>[];
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        final model = AyatModel.fromBookmarkJson(map);
        bookmarks.add(
          model.toEntity(
            nomorSurah: map['nomorSurah'] as int?,
            namaSurahLatin: map['namaSurahLatin'] as String?,
          ),
        );
      }
    }
    bookmarks.sort((a, b) {
      final surahCompare = (a.nomorSurah ?? 0).compareTo(b.nomorSurah ?? 0);
      if (surahCompare != 0) return surahCompare;
      return a.nomorAyat.compareTo(b.nomorAyat);
    });
    return bookmarks;
  }

  @override
  Future<void> addBookmark(AyatEntity ayat) async {
    if (ayat.nomorSurah == null || ayat.namaSurahLatin == null) {
      throw Exception('Data surah ayat tidak lengkap');
    }
    final model = AyatModel.fromEntity(ayat);
    final key = Helpers.bookmarkKey(
      nomorSurah: ayat.nomorSurah!,
      nomorAyat: ayat.nomorAyat,
    );
    await _box.put(
      key,
      model.toJson(
        nomorSurah: ayat.nomorSurah!,
        namaSurahLatin: ayat.namaSurahLatin!,
      ),
    );
  }

  @override
  Future<void> removeBookmark(int nomorSurah, int nomorAyat) async {
    final key = Helpers.bookmarkKey(
      nomorSurah: nomorSurah,
      nomorAyat: nomorAyat,
    );
    await _box.delete(key);
  }

  @override
  Future<bool> isBookmarked(int nomorSurah, int nomorAyat) async {
    final key = Helpers.bookmarkKey(
      nomorSurah: nomorSurah,
      nomorAyat: nomorAyat,
    );
    return _box.containsKey(key);
  }
}
