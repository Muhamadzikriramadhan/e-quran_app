import 'package:equatable/equatable.dart';
import 'surah_entity.dart';

class SurahDetailEntity extends Equatable {
  final int? code;
  final String? message;
  final SurahDetailDataEntity? data;

  const SurahDetailEntity({this.code, this.message, this.data});

  @override
  List<Object?> get props => [code, message, data];
}

class SurahDetailDataEntity extends Equatable {
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final String? arti;
  final String? deskripsi;
  final AudioFullEntity? audioFull;
  final List<AyatEntity>? ayat;
  final dynamic suratSelanjutnya;
  final dynamic suratSebelumnya;

  const SurahDetailDataEntity({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audioFull,
    this.ayat,
    this.suratSelanjutnya,
    this.suratSebelumnya,
  });

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

class AyatEntity extends Equatable {
  final int? nomorAyat;
  final String? teksArab;
  final String? teksLatin;
  final String? teksIndonesia;
  final AudioFullEntity? audio;

  const AyatEntity({
    this.nomorAyat,
    this.teksArab,
    this.teksLatin,
    this.teksIndonesia,
    this.audio,
  });

  @override
  List<Object?> get props => [nomorAyat, teksArab, teksLatin, teksIndonesia, audio];
}

class SuratSelanjutnyaEntity extends Equatable {
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;

  const SuratSelanjutnyaEntity({this.nomor, this.nama, this.namaLatin, this.jumlahAyat});

  @override
  List<Object?> get props => [nomor, nama, namaLatin, jumlahAyat];
}
