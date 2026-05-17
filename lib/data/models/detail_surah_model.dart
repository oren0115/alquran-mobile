import '../../domain/entities/surah_entity.dart';
import 'ayat_model.dart';
import 'surah_model.dart';

class DetailSurahModel {
  const DetailSurahModel({
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
  final List<AyatModel> ayat;
  final SurahNavModel? suratSelanjutnya;
  final SurahNavModel? suratSebelumnya;

  factory DetailSurahModel.fromJson(Map<String, dynamic> json) {
    final ayatList = (json['ayat'] as List<dynamic>)
        .map((e) => AyatModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return DetailSurahModel(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      jumlahAyat: json['jumlahAyat'] as int,
      tempatTurun: json['tempatTurun'] as String,
      arti: json['arti'] as String,
      deskripsi: json['deskripsi'] as String?,
      audioFull: SurahModel.parseAudioMap(json['audioFull']),
      ayat: ayatList,
      suratSelanjutnya: _parseNav(json['suratSelanjutnya']),
      suratSebelumnya: _parseNav(json['suratSebelumnya']),
    );
  }

  DetailSurahEntity toEntity() {
    return DetailSurahEntity(
      nomor: nomor,
      nama: nama,
      namaLatin: namaLatin,
      jumlahAyat: jumlahAyat,
      tempatTurun: tempatTurun,
      arti: arti,
      deskripsi: deskripsi,
      audioFull: audioFull,
      ayat: ayat
          .map(
            (a) => a.toEntity(
              nomorSurah: nomor,
              namaSurahLatin: namaLatin,
            ),
          )
          .toList(),
      suratSelanjutnya: suratSelanjutnya?.toEntity(),
      suratSebelumnya: suratSebelumnya?.toEntity(),
    );
  }

  static SurahNavModel? _parseNav(dynamic value) {
    if (value is! Map<String, dynamic>) return null;
    return SurahNavModel.fromJson(value);
  }
}

class TafsirModel {
  const TafsirModel({
    required this.nomor,
    required this.namaLatin,
    required this.tafsir,
  });

  final int nomor;
  final String namaLatin;
  final List<TafsirAyatModel> tafsir;

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    final list = (json['tafsir'] as List<dynamic>)
        .map((e) => TafsirAyatModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return TafsirModel(
      nomor: json['nomor'] as int,
      namaLatin: json['namaLatin'] as String,
      tafsir: list,
    );
  }

  TafsirEntity toEntity() {
    return TafsirEntity(
      nomor: nomor,
      namaLatin: namaLatin,
      tafsir: tafsir.map((t) => t.toEntity()).toList(),
    );
  }
}

class TafsirAyatModel {
  const TafsirAyatModel({
    required this.ayat,
    required this.teks,
  });

  final int ayat;
  final String teks;

  factory TafsirAyatModel.fromJson(Map<String, dynamic> json) {
    return TafsirAyatModel(
      ayat: json['ayat'] as int,
      teks: json['teks'] as String,
    );
  }

  TafsirAyatEntity toEntity() {
    return TafsirAyatEntity(ayat: ayat, teks: teks);
  }
}
