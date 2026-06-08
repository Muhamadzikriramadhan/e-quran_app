import '../../domain/entities/asmaul_husna_entity.dart';

class AsmaulHusnaModel extends AsmaulHusnaEntity {
  const AsmaulHusnaModel({super.status, super.data});

  factory AsmaulHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaulHusnaModel(
      status: json['status'],
      data: json['data'] != null
          ? List<AsmaulHusnaDataModel>.from(
              json['data'].map((x) => AsmaulHusnaDataModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data != null
          ? List<dynamic>.from(data!.map((x) => (x as AsmaulHusnaDataModel).toJson()))
          : null,
    };
  }
}

class AsmaulHusnaDataModel extends AsmaulHusnaDataEntity {
  const AsmaulHusnaDataModel({super.sId, super.arab, super.id, super.indo, super.latin});

  factory AsmaulHusnaDataModel.fromJson(Map<String, dynamic> json) {
    return AsmaulHusnaDataModel(
      sId: json['_id'],
      arab: json['arab'],
      id: json['id'],
      indo: json['indo'],
      latin: json['latin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'arab': arab,
      'id': id,
      'indo': indo,
      'latin': latin,
    };
  }
}
