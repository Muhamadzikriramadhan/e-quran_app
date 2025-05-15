part of 'doa_bloc.dart';

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
  final DoaList doaList;

  const DoaSuccess(this.doaList);

  @override
  List<Object> get props => [doaList];
}
