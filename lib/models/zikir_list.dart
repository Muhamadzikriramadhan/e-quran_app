class ZikirList {
  int? status;
  List<Data>? data;

  ZikirList({this.status, this.data});

  ZikirList.fromJson(Map<String, dynamic> json) {
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
  String? type;
  String? ulang;

  Data({this.sId, this.arab, this.indo, this.type, this.ulang});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    arab = json['arab'];
    indo = json['indo'];
    type = json['type'];
    ulang = json['ulang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['arab'] = this.arab;
    data['indo'] = this.indo;
    data['type'] = this.type;
    data['ulang'] = this.ulang;
    return data;
  }
}