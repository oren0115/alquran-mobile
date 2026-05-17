import 'package:equatable/equatable.dart';

class AyatEntity extends Equatable {
  const AyatEntity({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    this.audio,
    this.nomorSurah,
    this.namaSurahLatin,
  });

  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String>? audio;
  final int? nomorSurah;
  final String? namaSurahLatin;

  String get bookmarkId {
    if (nomorSurah == null) return '$nomorAyat';
    return '${nomorSurah}_$nomorAyat';
  }

  AyatEntity copyWith({
    int? nomorAyat,
    String? teksArab,
    String? teksLatin,
    String? teksIndonesia,
    Map<String, String>? audio,
    int? nomorSurah,
    String? namaSurahLatin,
  }) {
    return AyatEntity(
      nomorAyat: nomorAyat ?? this.nomorAyat,
      teksArab: teksArab ?? this.teksArab,
      teksLatin: teksLatin ?? this.teksLatin,
      teksIndonesia: teksIndonesia ?? this.teksIndonesia,
      audio: audio ?? this.audio,
      nomorSurah: nomorSurah ?? this.nomorSurah,
      namaSurahLatin: namaSurahLatin ?? this.namaSurahLatin,
    );
  }

  @override
  List<Object?> get props => [
        nomorAyat,
        teksArab,
        teksLatin,
        teksIndonesia,
        audio,
        nomorSurah,
        namaSurahLatin,
      ];
}
