part of 'zikir_bloc.dart';

abstract class ZikirState extends Equatable {
  const ZikirState();

  @override
  List<Object> get props => [];
}

class ZikirInitial extends ZikirState {}

class ZikirLoading extends ZikirState {}

class ZikirFailed extends ZikirState {
  final String e;

  const ZikirFailed(this.e);

  @override
  List<Object> get props => [e];
}

class ZikirSuccess extends ZikirState {
  final ZikirList zikirList;

  const ZikirSuccess(this.zikirList);

  @override
  List<Object> get props => [zikirList];
}
