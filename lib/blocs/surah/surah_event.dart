part of 'surah_bloc.dart';

abstract class SurahEvent extends Equatable {

  const SurahEvent();

  @override
  List<Object> get props => [];
}

class GetListSurah extends SurahEvent {
  final String url;

  const GetListSurah(this.url);

  @override
  List<Object> get props => [url];
}
