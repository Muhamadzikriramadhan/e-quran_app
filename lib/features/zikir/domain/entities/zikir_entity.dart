import 'package:equatable/equatable.dart';

class ZikirEntity extends Equatable {
  final int? status;
  final List<ZikirDataEntity>? data;

  const ZikirEntity({this.status, this.data});

  @override
  List<Object?> get props => [status, data];
}

class ZikirDataEntity extends Equatable {
  final String? sId;
  final String? arab;
  final String? indo;
  final String? type;
  final String? ulang;

  const ZikirDataEntity({this.sId, this.arab, this.indo, this.type, this.ulang});

  @override
  List<Object?> get props => [sId, arab, indo, type, ulang];
}
