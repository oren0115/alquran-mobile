import '../../domain/entities/surah_entity.dart';

class SurahModel {
  const SurahModel({
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

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
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

  SurahEntity toEntity() {
    return SurahEntity(
      nomor: nomor,
      nama: nama,
      namaLatin: namaLatin,
      jumlahAyat: jumlahAyat,
      tempatTurun: tempatTurun,
      arti: arti,
      deskripsi: deskripsi,
      audioFull: audioFull,
    );
  }

  static Map<String, String>? parseAudioMap(dynamic value) {
    if (value is! Map) return null;
    return value.map(
      (key, val) => MapEntry(key.toString(), val.toString()),
    );
  }
}

class SurahNavModel {
  const SurahNavModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
  });

  final int nomor;
  final String nama;
  final String namaLatin;

  factory SurahNavModel.fromJson(Map<String, dynamic> json) {
    return SurahNavModel(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
    );
  }

  SurahNavEntity toEntity() {
    return SurahNavEntity(
      nomor: nomor,
      nama: nama,
      namaLatin: namaLatin,
    );
  }
}
