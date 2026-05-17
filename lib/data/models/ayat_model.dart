import '../../domain/entities/ayat_entity.dart';
import 'surah_model.dart';

class AyatModel {
  const AyatModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    this.audio,
  });

  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String>? audio;

  factory AyatModel.fromJson(Map<String, dynamic> json) {
    return AyatModel(
      nomorAyat: json['nomorAyat'] as int,
      teksArab: json['teksArab'] as String,
      teksLatin: json['teksLatin'] as String,
      teksIndonesia: json['teksIndonesia'] as String,
      audio: SurahModel.parseAudioMap(json['audio']),
    );
  }

  AyatEntity toEntity({int? nomorSurah, String? namaSurahLatin}) {
    return AyatEntity(
      nomorAyat: nomorAyat,
      teksArab: teksArab,
      teksLatin: teksLatin,
      teksIndonesia: teksIndonesia,
      audio: audio,
      nomorSurah: nomorSurah,
      namaSurahLatin: namaSurahLatin,
    );
  }

  factory AyatModel.fromEntity(AyatEntity entity) {
    return AyatModel(
      nomorAyat: entity.nomorAyat,
      teksArab: entity.teksArab,
      teksLatin: entity.teksLatin,
      teksIndonesia: entity.teksIndonesia,
      audio: entity.audio,
    );
  }

  Map<String, dynamic> toJson({
    required int nomorSurah,
    required String namaSurahLatin,
  }) {
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

  static AyatModel fromBookmarkJson(Map<String, dynamic> json) {
    return AyatModel(
      nomorAyat: json['nomorAyat'] as int,
      teksArab: json['teksArab'] as String,
      teksLatin: json['teksLatin'] as String,
      teksIndonesia: json['teksIndonesia'] as String,
      audio: SurahModel.parseAudioMap(json['audio']),
    );
  }

  static Map<String, String>? parseAudioMap(dynamic value) {
    if (value is! Map) return null;
    return value.map((key, val) => MapEntry(key.toString(), val.toString()));
  }
}
