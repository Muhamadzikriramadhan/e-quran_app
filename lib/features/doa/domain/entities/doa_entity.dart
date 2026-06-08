import 'package:equatable/equatable.dart';

class DoaEntity extends Equatable {
  final int? status;
  final List<DoaDataEntity>? data;

  const DoaEntity({this.status, this.data});

  @override
  List<Object?> get props => [status, data];
}

class DoaDataEntity extends Equatable {
  final String? sId;
  final String? arab;
  final String? indo;
  final String? judul;
  final String? source;

  const DoaDataEntity({this.sId, this.arab, this.indo, this.judul, this.source});

  @override
  List<Object?> get props => [sId, arab, indo, judul, source];
}
