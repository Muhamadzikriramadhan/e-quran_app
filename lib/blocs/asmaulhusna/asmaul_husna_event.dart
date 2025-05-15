part of 'asmaul_husna_bloc.dart';

abstract class AsmaulHusnaEvent extends Equatable {

  const AsmaulHusnaEvent();

  @override
  List<Object> get props => [];
}

class GetAsmaulHusna extends AsmaulHusnaEvent {
  final String url;

  const GetAsmaulHusna(this.url);

  @override
  List<Object> get props => [url];
}
