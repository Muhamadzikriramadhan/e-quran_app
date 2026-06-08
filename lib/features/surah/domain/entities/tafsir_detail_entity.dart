import 'package:equatable/equatable.dart';
import 'surah_entity.dart';


class TafsirDetailEntity extends Equatable {
  final int? code;
  final String? message;
  final TafsirDetailDataEntity? data;

  const TafsirDetailEntity({this.code, this.message, this.data});

  @override
  List<Object?> get props => [code, message, data];
}

class TafsirDetailDataEntity extends Equatable {
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final String? arti;
  final String? deskripsi;
  final AudioFullEntity? audioFull;
  final List<TafsirEntity>? tafsir;
  final dynamic suratSelanjutnya;
  final dynamic suratSebelumnya;

  const TafsirDetailDataEntity({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audioFull,
    this.tafsir,
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
        tafsir,
        suratSelanjutnya,
        suratSebelumnya,
      ];
}

class TafsirEntity extends Equatable {
  final int? ayat;
  final String? teks;

  const TafsirEntity({this.ayat, this.teks});

  @override
  List<Object?> get props => [ayat, teks];
}
