class TafsirDetail {
  int? code;
  String? message;
  Data? data;

  TafsirDetail({this.code, this.message, this.data});

  TafsirDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;
  String? tempatTurun;
  String? arti;
  String? deskripsi;
  AudioFull? audioFull;
  List<Tafsir>? tafsir;
  dynamic? suratSelanjutnya;
  dynamic? suratSebelumnya;

  Data(
      {this.nomor,
        this.nama,
        this.namaLatin,
        this.jumlahAyat,
        this.tempatTurun,
        this.arti,
        this.deskripsi,
        this.audioFull,
        this.tafsir,
        this.suratSelanjutnya,
        this.suratSebelumnya});

  Data.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    nama = json['nama'];
    namaLatin = json['namaLatin'];
    jumlahAyat = json['jumlahAyat'];
    tempatTurun = json['tempatTurun'];
    arti = json['arti'];
    deskripsi = json['deskripsi'];
    audioFull = json['audioFull'] != null
        ? new AudioFull.fromJson(json['audioFull'])
        : null;
    if (json['tafsir'] != null) {
      tafsir = <Tafsir>[];
      json['tafsir'].forEach((v) {
        tafsir!.add(new Tafsir.fromJson(v));
      });
    }
    if (json['suratSelanjutnya'] is bool) {
      suratSelanjutnya = json['suratSelanjutnya'];
    } else if (json['suratSelanjutnya'] is Map<String, dynamic>) {
      suratSelanjutnya = SuratSelanjutnya.fromJson(json['suratSelanjutnya']);
    } else {
      suratSelanjutnya = null;
    }
    if (json['suratSebelumnya'] is bool) {
      suratSebelumnya = json['suratSebelumnya'];
    } else if (json['suratSebelumnya'] is Map<String, dynamic>) {
      suratSebelumnya = SuratSelanjutnya.fromJson(json['suratSebelumnya']);
    } else {
      suratSebelumnya = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomor'] = this.nomor;
    data['nama'] = this.nama;
    data['namaLatin'] = this.namaLatin;
    data['jumlahAyat'] = this.jumlahAyat;
    data['tempatTurun'] = this.tempatTurun;
    data['arti'] = this.arti;
    data['deskripsi'] = this.deskripsi;
    if (this.audioFull != null) {
      data['audioFull'] = this.audioFull!.toJson();
    }
    if (this.tafsir != null) {
      data['tafsir'] = this.tafsir!.map((v) => v.toJson()).toList();
    }
    if (suratSelanjutnya is bool) {
      data['suratSelanjutnya'] = suratSelanjutnya;
    } else if (suratSelanjutnya is SuratSelanjutnya) {
      data['suratSelanjutnya'] = (suratSelanjutnya as SuratSelanjutnya).toJson();
    }
    if (suratSebelumnya is bool) {
      data['suratSebelumnya'] = suratSebelumnya;
    } else if (suratSebelumnya is SuratSelanjutnya) {
      data['suratSebelumnya'] = (suratSebelumnya as SuratSelanjutnya).toJson();
    }
    return data;
  }
}

class AudioFull {
  String? s01;
  String? s02;
  String? s03;
  String? s04;
  String? s05;

  AudioFull({this.s01, this.s02, this.s03, this.s04, this.s05});

  AudioFull.fromJson(Map<String, dynamic> json) {
    s01 = json['01'];
    s02 = json['02'];
    s03 = json['03'];
    s04 = json['04'];
    s05 = json['05'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['01'] = this.s01;
    data['02'] = this.s02;
    data['03'] = this.s03;
    data['04'] = this.s04;
    data['05'] = this.s05;
    return data;
  }
}

class Tafsir {
  int? ayat;
  String? teks;

  Tafsir({this.ayat, this.teks});

  Tafsir.fromJson(Map<String, dynamic> json) {
    ayat = json['ayat'];
    teks = json['teks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ayat'] = this.ayat;
    data['teks'] = this.teks;
    return data;
  }
}

class SuratSelanjutnya {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;

  SuratSelanjutnya({this.nomor, this.nama, this.namaLatin, this.jumlahAyat});

  SuratSelanjutnya.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    nama = json['nama'];
    namaLatin = json['namaLatin'];
    jumlahAyat = json['jumlahAyat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomor'] = this.nomor;
    data['nama'] = this.nama;
    data['namaLatin'] = this.namaLatin;
    data['jumlahAyat'] = this.jumlahAyat;
    return data;
  }
}