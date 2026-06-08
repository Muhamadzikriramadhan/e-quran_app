import 'package:equatable/equatable.dart';

class SurahListEntity extends Equatable {
  final int? code;
  final String? message;
  final List<SurahDataEntity>? data;

  const SurahListEntity({this.code, this.message, this.data});

  @override
  List<Object?> get props => [code, message, data];
}

class SurahDataEntity extends Equatable {
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final String? arti;
  final String? deskripsi;
  final AudioFullEntity? audioFull;

  const SurahDataEntity({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audioFull,
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
      ];
}

class AudioFullEntity extends Equatable {
  final String? s01;
  final String? s02;
  final String? s03;
  final String? s04;
  final String? s05;

  const AudioFullEntity({this.s01, this.s02, this.s03, this.s04, this.s05});

  @override
  List<Object?> get props => [s01, s02, s03, s04, s05];
}
