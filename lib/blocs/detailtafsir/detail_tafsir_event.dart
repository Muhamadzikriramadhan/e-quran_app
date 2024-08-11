part of 'detail_tafsir_bloc.dart';

abstract class DetailTafsirEvent extends Equatable {

  const DetailTafsirEvent();

  @override
  List<Object> get props => [];
}

class DetailTafsirGetBySurahNumber extends DetailTafsirEvent {
  final String url;

  const DetailTafsirGetBySurahNumber(this.url);

  @override
  List<Object> get props => [url];
}

class DetailTafsirGetRecent extends DetailTafsirEvent {}
