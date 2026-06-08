import 'package:equatable/equatable.dart';

class AsmaulHusnaEntity extends Equatable {
  final int? status;
  final List<AsmaulHusnaDataEntity>? data;

  const AsmaulHusnaEntity({this.status, this.data});

  @override
  List<Object?> get props => [status, data];
}

class AsmaulHusnaDataEntity extends Equatable {
  final String? sId;
  final String? arab;
  final int? id;
  final String? indo;
  final String? latin;

  const AsmaulHusnaDataEntity({this.sId, this.arab, this.id, this.indo, this.latin});

  @override
  List<Object?> get props => [sId, arab, id, indo, latin];
}
