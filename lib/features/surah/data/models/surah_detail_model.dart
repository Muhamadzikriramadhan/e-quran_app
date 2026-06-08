import '../../domain/entities/surah_detail_entity.dart';
import 'surah_list_model.dart';

class SurahDetailModel extends SurahDetailEntity {
  const SurahDetailModel({super.code, super.message, super.data});

  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    return SurahDetailModel(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? SurahDetailDataModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data != null ? (data as SurahDetailDataModel).toJson() : null,
    };
  }
}

class SurahDetailDataModel extends SurahDetailDataEntity {
  const SurahDetailDataModel({
    super.nomor,
    super.nama,
    super.namaLatin,
    super.jumlahAyat,
    super.tempatTurun,
    super.arti,
    super.deskripsi,
    super.audioFull,
    super.ayat,
    super.suratSelanjutnya,
    super.suratSebelumnya,
  });

  factory SurahDetailDataModel.fromJson(Map<String, dynamic> json) {
    dynamic nextSurah;
    if (json['suratSelanjutnya'] is Map<String, dynamic>) {
      nextSurah = SuratSelanjutnyaModel.fromJson(json['suratSelanjutnya']);
    } else {
      nextSurah = json['suratSelanjutnya'];
    }

    dynamic prevSurah;
    if (json['suratSebelumnya'] is Map<String, dynamic>) {
      prevSurah = SuratSelanjutnyaModel.fromJson(json['suratSebelumnya']);
    } else {
      prevSurah = json['suratSebelumnya'];
    }

    return SurahDetailDataModel(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audioFull: json['audioFull'] != null ? AudioFullModel.fromJson(json['audioFull']) : null,
      ayat: json['ayat'] != null
          ? List<AyatModel>.from(json['ayat'].map((x) => AyatModel.fromJson(x)))
          : null,
      suratSelanjutnya: nextSurah,
      suratSebelumnya: prevSurah,
    );
  }

  Map<String, dynamic> toJson() {
    dynamic nextJson;
    if (suratSelanjutnya is SuratSelanjutnyaModel) {
      nextJson = (suratSelanjutnya as SuratSelanjutnyaModel).toJson();
    } else {
      nextJson = suratSelanjutnya;
    }

    dynamic prevJson;
    if (suratSebelumnya is SuratSelanjutnyaModel) {
      prevJson = (suratSebelumnya as SuratSelanjutnyaModel).toJson();
    } else {
      prevJson = suratSebelumnya;
    }

    return {
      'nomor': nomor,
      'nama': nama,
      'namaLatin': namaLatin,
      'jumlahAyat': jumlahAyat,
      'tempatTurun': tempatTurun,
      'arti': arti,
      'deskripsi': deskripsi,
      'audioFull': audioFull != null ? (audioFull as AudioFullModel).toJson() : null,
      'ayat': ayat != null ? List<dynamic>.from(ayat!.map((x) => (x as AyatModel).toJson())) : null,
      'suratSelanjutnya': nextJson,
      'suratSebelumnya': prevJson,
    };
  }
}

class AyatModel extends AyatEntity {
  const AyatModel({
    super.nomorAyat,
    super.teksArab,
    super.teksLatin,
    super.teksIndonesia,
    super.audio,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) {
    return AyatModel(
      nomorAyat: json['nomorAyat'],
      teksArab: json['teksArab'],
      teksLatin: json['teksLatin'],
      teksIndonesia: json['teksIndonesia'],
      audio: json['audio'] != null ? AudioFullModel.fromJson(json['audio']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomorAyat': nomorAyat,
      'teksArab': teksArab,
      'teksLatin': teksLatin,
      'teksIndonesia': teksIndonesia,
      'audio': audio != null ? (audio as AudioFullModel).toJson() : null,
    };
  }
}

class SuratSelanjutnyaModel extends SuratSelanjutnyaEntity {
  const SuratSelanjutnyaModel({super.nomor, super.nama, super.namaLatin, super.jumlahAyat});

  factory SuratSelanjutnyaModel.fromJson(Map<String, dynamic> json) {
    return SuratSelanjutnyaModel(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomor': nomor,
      'nama': nama,
      'namaLatin': namaLatin,
      'jumlahAyat': jumlahAyat,
    };
  }
}
