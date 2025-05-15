class DoaList {
  int? status;
  List<Data>? data;

  DoaList({this.status, this.data});

  DoaList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? arab;
  String? indo;
  String? judul;
  String? source;

  Data({this.sId, this.arab, this.indo, this.judul, this.source});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    arab = json['arab'];
    indo = json['indo'];
    judul = json['judul'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['arab'] = this.arab;
    data['indo'] = this.indo;
    data['judul'] = this.judul;
    data['source'] = this.source;
    return data;
  }
}