import 'package:equatable/equatable.dart';

import '../models/ayat.dart';

enum BookmarkStatus { initial, loading, loaded, error }

class BookmarkState extends Equatable {
  const BookmarkState({
    this.status = BookmarkStatus.initial,
    this.bookmarks = const [],
    this.errorMessage,
  });

  final BookmarkStatus status;
  final List<Ayat> bookmarks;
  final String? errorMessage;

  BookmarkState copyWith({
    BookmarkStatus? status,
    List<Ayat>? bookmarks,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool isBookmarked(int nomorSurah, int nomorAyat) {
    return bookmarks.any(
      (b) => b.nomorSurah == nomorSurah && b.nomorAyat == nomorAyat,
    );
  }

  @override
  List<Object?> get props => [status, bookmarks, errorMessage];
}
