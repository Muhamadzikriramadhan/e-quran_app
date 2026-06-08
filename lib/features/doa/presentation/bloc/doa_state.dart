import 'package:equatable/equatable.dart';
import '../../domain/entities/doa_entity.dart';

abstract class DoaState extends Equatable {
  const DoaState();

  @override
  List<Object> get props => [];
}

class DoaInitial extends DoaState {}

class DoaLoading extends DoaState {}

class DoaFailed extends DoaState {
  final String e;

  const DoaFailed(this.e);

  @override
  List<Object> get props => [e];
}

class DoaSuccess extends DoaState {
  final DoaEntity doaList;

  const DoaSuccess(this.doaList);

  @override
  List<Object> get props => [doaList];
}
