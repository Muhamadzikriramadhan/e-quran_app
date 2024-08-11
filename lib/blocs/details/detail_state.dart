part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailFailed extends DetailState {
  final String e;

  const DetailFailed(this.e);

  @override
  List<Object> get props => [e];
}

class DetailSuccess extends DetailState {
  final SurahDetail details;

  const DetailSuccess(this.details);

  @override
  List<Object> get props => [details];
}
