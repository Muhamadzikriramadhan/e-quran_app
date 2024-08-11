part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {

  const DetailEvent();

  @override
  List<Object> get props => [];
}

class DetailGetBySurahNumber extends DetailEvent {
  final String url;

  const DetailGetBySurahNumber(this.url);

  @override
  List<Object> get props => [url];
}

class DetailGetRecent extends DetailEvent {}
