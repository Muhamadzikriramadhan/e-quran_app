import 'package:equatable/equatable.dart';
import '../../domain/entities/asmaul_husna_entity.dart';

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
  final AsmaulHusnaEntity asmaulHusna;

  const AsmaulHusnaSuccess(this.asmaulHusna);

  @override
  List<Object> get props => [asmaulHusna];
}
