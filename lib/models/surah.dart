import 'package:equatable/equatable.dart';

import 'ayat.dart';

class Surah extends Equatable {
  const Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    this.deskripsi,
    this.audioFull,
  });

  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String? deskripsi;
  final Map<String, String>? audioFull;

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      jumlahAyat: json['jumlahAyat'] as int,
      tempatTurun: json['tempatTurun'] as String,
      arti: json['arti'] as String,
      deskripsi: json['deskripsi'] as String?,
      audioFull: parseAudioMap(json['audioFull']),
    );
  }

  static Map<String, String>? parseAudioMap(dynamic value) {
    if (value is! Map) return null;
    return value.map(
      (key, val) => MapEntry(key.toString(), val.toString()),
    );
  }

  @override
  List<Object?> get props => [
        nomor,
        nama,
        namaLatin,
        jumlahAyat,
        tempatTurun,
        arti,
        deskripsi,
        audioFull,
      ];
}

class SurahNav extends Equatable {
  const SurahNav({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
  });

  final int nomor;
  final String nama;
  final String namaLatin;

  factory SurahNav.fromJson(Map<String, dynamic> json) {
    return SurahNav(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
    );
  }

  @override
  List<Object?> get props => [nomor, nama, namaLatin];
}

class DetailSurah extends Equatable {
  const DetailSurah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.ayat,
    this.deskripsi,
    this.audioFull,
    this.suratSelanjutnya,
    this.suratSebelumnya,
  });

  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String? deskripsi;
  final Map<String, String>? audioFull;
  final List<Ayat> ayat;
  final SurahNav? suratSelanjutnya;
  final SurahNav? suratSebelumnya;

  factory DetailSurah.fromJson(Map<String, dynamic> json) {
    final nomor = json['nomor'] as int;
    final namaLatin = json['namaLatin'] as String;
    final ayatList = (json['ayat'] as List<dynamic>)
        .map(
          (e) => Ayat.fromJson(
            e as Map<String, dynamic>,
            nomorSurah: nomor,
            namaSurahLatin: namaLatin,
          ),
        )
        .toList();

    return DetailSurah(
      nomor: nomor,
      nama: json['nama'] as String,
      namaLatin: namaLatin,
      jumlahAyat: json['jumlahAyat'] as int,
      tempatTurun: json['tempatTurun'] as String,
      arti: json['arti'] as String,
      deskripsi: json['deskripsi'] as String?,
      audioFull: Surah.parseAudioMap(json['audioFull']),
      ayat: ayatList,
      suratSelanjutnya: _parseNav(json['suratSelanjutnya']),
      suratSebelumnya: _parseNav(json['suratSebelumnya']),
    );
  }

  static SurahNav? _parseNav(dynamic value) {
    if (value is! Map<String, dynamic>) return null;
    return SurahNav.fromJson(value);
  }

  @override
  List<Object?> get props => [
        nomor,
        nama,
        namaLatin,
        jumlahAyat,
        tempatTurun,
        arti,
        deskripsi,
        audioFull,
        ayat,
        suratSelanjutnya,
        suratSebelumnya,
      ];
}

class Tafsir extends Equatable {
  const Tafsir({
    required this.nomor,
    required this.namaLatin,
    required this.tafsir,
  });

  final int nomor;
  final String namaLatin;
  final List<TafsirAyat> tafsir;

  factory Tafsir.fromJson(Map<String, dynamic> json) {
    final list = (json['tafsir'] as List<dynamic>)
        .map((e) => TafsirAyat.fromJson(e as Map<String, dynamic>))
        .toList();

    return Tafsir(
      nomor: json['nomor'] as int,
      namaLatin: json['namaLatin'] as String,
      tafsir: list,
    );
  }

  @override
  List<Object?> get props => [nomor, namaLatin, tafsir];
}

class TafsirAyat extends Equatable {
  const TafsirAyat({
    required this.ayat,
    required this.teks,
  });

  final int ayat;
  final String teks;

  factory TafsirAyat.fromJson(Map<String, dynamic> json) {
    return TafsirAyat(
      ayat: json['ayat'] as int,
      teks: json['teks'] as String,
    );
  }

  @override
  List<Object?> get props => [ayat, teks];
}
