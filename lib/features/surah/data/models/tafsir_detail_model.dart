import '../../domain/entities/tafsir_detail_entity.dart';
import 'surah_list_model.dart';
import 'surah_detail_model.dart';

class TafsirDetailModel extends TafsirDetailEntity {
  const TafsirDetailModel({super.code, super.message, super.data});

  factory TafsirDetailModel.fromJson(Map<String, dynamic> json) {
    return TafsirDetailModel(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? TafsirDetailDataModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data != null ? (data as TafsirDetailDataModel).toJson() : null,
    };
  }
}

class TafsirDetailDataModel extends TafsirDetailDataEntity {
  const TafsirDetailDataModel({
    super.nomor,
    super.nama,
    super.namaLatin,
    super.jumlahAyat,
    super.tempatTurun,
    super.arti,
    super.deskripsi,
    super.audioFull,
    super.tafsir,
    super.suratSelanjutnya,
    super.suratSebelumnya,
  });

  factory TafsirDetailDataModel.fromJson(Map<String, dynamic> json) {
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

    return TafsirDetailDataModel(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audioFull: json['audioFull'] != null ? AudioFullModel.fromJson(json['audioFull']) : null,
      tafsir: json['tafsir'] != null
          ? List<TafsirModel>.from(json['tafsir'].map((x) => TafsirModel.fromJson(x)))
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
      'tafsir': tafsir != null ? List<dynamic>.from(tafsir!.map((x) => (x as TafsirModel).toJson())) : null,
      'suratSelanjutnya': nextJson,
      'suratSebelumnya': prevJson,
    };
  }
}

class TafsirModel extends TafsirEntity {
  const TafsirModel({super.ayat, super.teks});

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    return TafsirModel(
      ayat: json['ayat'],
      teks: json['teks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ayat': ayat,
      'teks': teks,
    };
  }
}
