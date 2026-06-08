import '../../domain/entities/doa_entity.dart';

class DoaModel extends DoaEntity {
  const DoaModel({super.status, super.data});

  factory DoaModel.fromJson(Map<String, dynamic> json) {
    return DoaModel(
      status: json['status'],
      data: json['data'] != null
          ? List<DoaDataModel>.from(json['data'].map((x) => DoaDataModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data != null
          ? List<dynamic>.from(data!.map((x) => (x as DoaDataModel).toJson()))
          : null,
    };
  }
}

class DoaDataModel extends DoaDataEntity {
  const DoaDataModel({super.sId, super.arab, super.indo, super.judul, super.source});

  factory DoaDataModel.fromJson(Map<String, dynamic> json) {
    return DoaDataModel(
      sId: json['_id'],
      arab: json['arab'],
      indo: json['indo'],
      judul: json['judul'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'arab': arab,
      'indo': indo,
      'judul': judul,
      'source': source,
    };
  }
}
