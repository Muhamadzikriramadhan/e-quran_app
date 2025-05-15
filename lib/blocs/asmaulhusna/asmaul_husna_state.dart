part of 'asmaul_husna_bloc.dart';

abstract class AsmaulHusnaState extends Equatable {
  const AsmaulHusnaState();

  @override
  List<Object> get props => [];
}

class AsmaulHusnaInitial extends AsmaulHusnaState {}

class AsmaulHusnaLoading extends AsmaulHusnaState {}

class AsmaulHusnaFailed extends AsmaulHusnaState {
  final String e;

  const AsmaulHusnaFailed(this.e);

  @override
  List<Object> get props => [e];
}

class AsmaulHusnaSuccess extends AsmaulHusnaState {
  final AsmaulHusna asmaulHusna;

  const AsmaulHusnaSuccess(this.asmaulHusna);

  @override
  List<Object> get props => [asmaulHusna];
}
