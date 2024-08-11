
class SurahList {
  int? _code;
  String? _message;
  List<Data>? _data;

  SurahList({int? code, String? message, List<Data>? data}) {
    if (code != null) {
      this._code = code;
    }
    if (message != null) {
      this._message = message;
    }
    if (data != null) {
      this._data = data;
    }
  }

  int? get code => _code;
  set code(int? code) => _code = code;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;

  SurahList.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? _nomor;
  String? _nama;
  String? _namaLatin;
  int? _jumlahAyat;
  String? _tempatTurun;
  String? _arti;
  String? _deskripsi;
  AudioFull? _audioFull;

  Data(
      {int? nomor,
        String? nama,
        String? namaLatin,
        int? jumlahAyat,
        String? tempatTurun,
        String? arti,
        String? deskripsi,
        AudioFull? audioFull}) {
    if (nomor != null) {
      this._nomor = nomor;
    }
    if (nama != null) {
      this._nama = nama;
    }
    if (namaLatin != null) {
      this._namaLatin = namaLatin;
    }
    if (jumlahAyat != null) {
      this._jumlahAyat = jumlahAyat;
    }
    if (tempatTurun != null) {
      this._tempatTurun = tempatTurun;
    }
    if (arti != null) {
      this._arti = arti;
    }
    if (deskripsi != null) {
      this._deskripsi = deskripsi;
    }
    if (audioFull != null) {
      this._audioFull = audioFull;
    }
  }

  int? get nomor => _nomor;
  set nomor(int? nomor) => _nomor = nomor;
  String? get nama => _nama;
  set nama(String? nama) => _nama = nama;
  String? get namaLatin => _namaLatin;
  set namaLatin(String? namaLatin) => _namaLatin = namaLatin;
  int? get jumlahAyat => _jumlahAyat;
  set jumlahAyat(int? jumlahAyat) => _jumlahAyat = jumlahAyat;
  String? get tempatTurun => _tempatTurun;
  set tempatTurun(String? tempatTurun) => _tempatTurun = tempatTurun;
  String? get arti => _arti;
  set arti(String? arti) => _arti = arti;
  String? get deskripsi => _deskripsi;
  set deskripsi(String? deskripsi) => _deskripsi = deskripsi;
  AudioFull? get audioFull => _audioFull;
  set audioFull(AudioFull? audioFull) => _audioFull = audioFull;

  Data.fromJson(Map<String, dynamic> json) {
    _nomor = json['nomor'];
    _nama = json['nama'];
    _namaLatin = json['namaLatin'];
    _jumlahAyat = json['jumlahAyat'];
    _tempatTurun = json['tempatTurun'];
    _arti = json['arti'];
    _deskripsi = json['deskripsi'];
    _audioFull = json['audioFull'] != null
        ? new AudioFull.fromJson(json['audioFull'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomor'] = this._nomor;
    data['nama'] = this._nama;
    data['namaLatin'] = this._namaLatin;
    data['jumlahAyat'] = this._jumlahAyat;
    data['tempatTurun'] = this._tempatTurun;
    data['arti'] = this._arti;
    data['deskripsi'] = this._deskripsi;
    if (this._audioFull != null) {
      data['audioFull'] = this._audioFull!.toJson();
    }
    return data;
  }
}

class AudioFull {
  String? _s01;
  String? _s02;
  String? _s03;
  String? _s04;
  String? _s05;

  AudioFull({String? s01, String? s02, String? s03, String? s04, String? s05}) {
    if (s01 != null) {
      this._s01 = s01;
    }
    if (s02 != null) {
      this._s02 = s02;
    }
    if (s03 != null) {
      this._s03 = s03;
    }
    if (s04 != null) {
      this._s04 = s04;
    }
    if (s05 != null) {
      this._s05 = s05;
    }
  }

  String? get s01 => _s01;
  set s01(String? s01) => _s01 = s01;
  String? get s02 => _s02;
  set s02(String? s02) => _s02 = s02;
  String? get s03 => _s03;
  set s03(String? s03) => _s03 = s03;
  String? get s04 => _s04;
  set s04(String? s04) => _s04 = s04;
  String? get s05 => _s05;
  set s05(String? s05) => _s05 = s05;

  AudioFull.fromJson(Map<String, dynamic> json) {
    _s01 = json['01'];
    _s02 = json['02'];
    _s03 = json['03'];
    _s04 = json['04'];
    _s05 = json['05'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['01'] = this._s01;
    data['02'] = this._s02;
    data['03'] = this._s03;
    data['04'] = this._s04;
    data['05'] = this._s05;
    return data;
  }
}