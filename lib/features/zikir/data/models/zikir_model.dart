import '../../domain/entities/zikir_entity.dart';

class ZikirModel extends ZikirEntity {
  const ZikirModel({super.status, super.data});

  factory ZikirModel.fromJson(Map<String, dynamic> json) {
    return ZikirModel(
      status: json['status'],
      data: json['data'] != null
          ? List<ZikirDataModel>.from(json['data'].map((x) => ZikirDataModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data != null
          ? List<dynamic>.from(data!.map((x) => (x as ZikirDataModel).toJson()))
          : null,
    };
  }
}

class ZikirDataModel extends ZikirDataEntity {
  const ZikirDataModel({super.sId, super.arab, super.indo, super.type, super.ulang});

  factory ZikirDataModel.fromJson(Map<String, dynamic> json) {
    return ZikirDataModel(
      sId: json['_id'],
      arab: json['arab'],
      indo: json['indo'],
      type: json['type'],
      ulang: json['ulang'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'arab': arab,
      'indo': indo,
      'type': type,
      'ulang': ulang,
    };
  }
}
