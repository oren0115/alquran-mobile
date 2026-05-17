import 'package:equatable/equatable.dart';

import 'ayat_entity.dart';

class SurahEntity extends Equatable {
  const SurahEntity({
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

class SurahNavEntity extends Equatable {
  const SurahNavEntity({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
  });

  final int nomor;
  final String nama;
  final String namaLatin;

  @override
  List<Object?> get props => [nomor, nama, namaLatin];
}

class DetailSurahEntity extends Equatable {
  const DetailSurahEntity({
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
  final List<AyatEntity> ayat;
  final SurahNavEntity? suratSelanjutnya;
  final SurahNavEntity? suratSebelumnya;

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

class TafsirEntity extends Equatable {
  const TafsirEntity({
    required this.nomor,
    required this.namaLatin,
    required this.tafsir,
  });

  final int nomor;
  final String namaLatin;
  final List<TafsirAyatEntity> tafsir;

  @override
  List<Object?> get props => [nomor, namaLatin, tafsir];
}

class TafsirAyatEntity extends Equatable {
  const TafsirAyatEntity({
    required this.ayat,
    required this.teks,
  });

  final int ayat;
  final String teks;

  @override
  List<Object?> get props => [ayat, teks];
}
