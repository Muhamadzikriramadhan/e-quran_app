import '../../domain/entities/surah_entity.dart';

class SurahListModel extends SurahListEntity {
  const SurahListModel({super.code, super.message, super.data});

  factory SurahListModel.fromJson(Map<String, dynamic> json) {
    return SurahListModel(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null
          ? List<SurahDataModel>.from(json['data'].map((x) => SurahDataModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data != null
          ? List<dynamic>.from(data!.map((x) => (x as SurahDataModel).toJson()))
          : null,
    };
  }
}

class SurahDataModel extends SurahDataEntity {
  const SurahDataModel({
    super.nomor,
    super.nama,
    super.namaLatin,
    super.jumlahAyat,
    super.tempatTurun,
    super.arti,
    super.deskripsi,
    super.audioFull,
  });

  factory SurahDataModel.fromJson(Map<String, dynamic> json) {
    return SurahDataModel(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audioFull: json['audioFull'] != null ? AudioFullModel.fromJson(json['audioFull']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomor': nomor,
      'nama': nama,
      'namaLatin': namaLatin,
      'jumlahAyat': jumlahAyat,
      'tempatTurun': tempatTurun,
      'arti': arti,
      'deskripsi': deskripsi,
      'audioFull': audioFull != null ? (audioFull as AudioFullModel).toJson() : null,
    };
  }
}

class AudioFullModel extends AudioFullEntity {
  const AudioFullModel({super.s01, super.s02, super.s03, super.s04, super.s05});

  factory AudioFullModel.fromJson(Map<String, dynamic> json) {
    return AudioFullModel(
      s01: json['01'],
      s02: json['02'],
      s03: json['03'],
      s04: json['04'],
      s05: json['05'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '01': s01,
      '02': s02,
      '03': s03,
      '04': s04,
      '05': s05,
    };
  }
}
