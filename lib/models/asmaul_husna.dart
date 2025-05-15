class AsmaulHusna {
  int? status;
  List<Data>? data;

  AsmaulHusna({this.status, this.data});

  AsmaulHusna.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? indo;
  String? latin;

  Data({this.sId, this.arab, this.id, this.indo, this.latin});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    arab = json['arab'];
    id = json['id'];
    indo = json['indo'];
    latin = json['latin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['arab'] = this.arab;
    data['id'] = this.id;
    data['indo'] = this.indo;
    data['latin'] = this.latin;
    return data;
  }
}