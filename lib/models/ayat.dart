import 'package:equatable/equatable.dart';

import 'surah.dart';

class Ayat extends Equatable {
  const Ayat({
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

  factory Ayat.fromJson(
    Map<String, dynamic> json, {
    int? nomorSurah,
    String? namaSurahLatin,
  }) {
    return Ayat(
      nomorAyat: json['nomorAyat'] as int,
      teksArab: json['teksArab'] as String,
      teksLatin: json['teksLatin'] as String,
      teksIndonesia: json['teksIndonesia'] as String,
      audio: Surah.parseAudioMap(json['audio']),
      nomorSurah: nomorSurah,
      namaSurahLatin: namaSurahLatin,
    );
  }

  factory Ayat.fromBookmarkJson(Map<String, dynamic> json) {
    return Ayat(
      nomorAyat: json['nomorAyat'] as int,
      teksArab: json['teksArab'] as String,
      teksLatin: json['teksLatin'] as String,
      teksIndonesia: json['teksIndonesia'] as String,
      audio: Surah.parseAudioMap(json['audio']),
      nomorSurah: json['nomorSurah'] as int?,
      namaSurahLatin: json['namaSurahLatin'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomorAyat': nomorAyat,
      'teksArab': teksArab,
      'teksLatin': teksLatin,
      'teksIndonesia': teksIndonesia,
      'audio': audio,
      'nomorSurah': nomorSurah,
      'namaSurahLatin': namaSurahLatin,
    };
  }

  Ayat copyWith({
    int? nomorAyat,
    String? teksArab,
    String? teksLatin,
    String? teksIndonesia,
    Map<String, String>? audio,
    int? nomorSurah,
    String? namaSurahLatin,
  }) {
    return Ayat(
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
