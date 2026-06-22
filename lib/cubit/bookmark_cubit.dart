import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ayat.dart';
import '../services/bookmark_service.dart';
import '../services/service_locator.dart';
import 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit({BookmarkService? bookmarkService})
      : _bookmarkService =
            bookmarkService ?? ServiceLocator.instance.bookmarkService,
        super(const BookmarkState());

  final BookmarkService _bookmarkService;

  Future<void> loadBookmarks() async {
    if (state.status == BookmarkStatus.loaded) return;
    emit(state.copyWith(status: BookmarkStatus.loading, clearError: true));
    try {
      final list = await _bookmarkService.getBookmarks();
      emit(state.copyWith(status: BookmarkStatus.loaded, bookmarks: list));
    } catch (e) {
      emit(
        state.copyWith(status: BookmarkStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: BookmarkStatus.loading, clearError: true));
    try {
      final list = await _bookmarkService.getBookmarks();
      emit(state.copyWith(status: BookmarkStatus.loaded, bookmarks: list));
    } catch (e) {
      emit(
        state.copyWith(status: BookmarkStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<bool> toggleBookmark(Ayat ayat) async {
    if (ayat.nomorSurah == null || ayat.namaSurahLatin == null) {
      throw Exception('Data surah ayat tidak lengkap');
    }

    final surah = ayat.nomorSurah!;
    final exists = await _bookmarkService.isBookmarked(surah, ayat.nomorAyat);

    if (exists) {
      await _bookmarkService.removeBookmark(surah, ayat.nomorAyat);
    } else {
      await _bookmarkService.addBookmark(ayat);
    }

    await refresh();
    return !exists;
  }
}
