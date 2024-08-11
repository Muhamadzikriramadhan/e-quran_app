part of 'detail_tafsir_bloc.dart';


abstract class DetailTafsirState extends Equatable {
  const DetailTafsirState();

  @override
  List<Object> get props => [];
}

class DetailTafsirInitial extends DetailTafsirState {}

class DetailTafsirLoading extends DetailTafsirState {}

class DetailTafsirFailed extends DetailTafsirState {
  final String e;

  const DetailTafsirFailed(this.e);

  @override
  List<Object> get props => [e];
}

class DetailTafsirSuccess extends DetailTafsirState {
  final TafsirDetail detailTafsir;

  const DetailTafsirSuccess(this.detailTafsir);

  @override
  List<Object> get props => [detailTafsir];
}
