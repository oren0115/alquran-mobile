import 'package:hive/hive.dart';

import '../models/ayat.dart';
import 'helpers.dart';

class BookmarkService {
  BookmarkService(this._box);

  static const String boxName = 'bookmarks';

  final Box<dynamic> _box;

  Future<List<Ayat>> getBookmarks() async {
    final bookmarks = <Ayat>[];
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map) {
        bookmarks.add(Ayat.fromBookmarkJson(Map<String, dynamic>.from(raw)));
      }
    }
    bookmarks.sort((a, b) {
      final surahCompare = (a.nomorSurah ?? 0).compareTo(b.nomorSurah ?? 0);
      if (surahCompare != 0) return surahCompare;
      return a.nomorAyat.compareTo(b.nomorAyat);
    });
    return bookmarks;
  }

  Future<void> addBookmark(Ayat ayat) async {
    if (ayat.nomorSurah == null || ayat.namaSurahLatin == null) {
      throw Exception('Data surah ayat tidak lengkap');
    }
    final key = Helpers.bookmarkKey(
      nomorSurah: ayat.nomorSurah!,
      nomorAyat: ayat.nomorAyat,
    );
    await _box.put(key, ayat.toJson());
  }

  Future<void> removeBookmark(int nomorSurah, int nomorAyat) async {
    final key = Helpers.bookmarkKey(
      nomorSurah: nomorSurah,
      nomorAyat: nomorAyat,
    );
    await _box.delete(key);
  }

  Future<bool> isBookmarked(int nomorSurah, int nomorAyat) async {
    final key = Helpers.bookmarkKey(
      nomorSurah: nomorSurah,
      nomorAyat: nomorAyat,
    );
    return _box.containsKey(key);
  }
}
