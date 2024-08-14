part of 'surah_bloc.dart';

abstract class SurahState extends Equatable {
  const SurahState();

  @override
  List<Object> get props => [];
}

class SurahInitial extends SurahState {}

class SurahLoading extends SurahState {}

class SurahFailed extends SurahState {
  final String e;

  const SurahFailed(this.e);

  @override
  List<Object> get props => [e];
}

class SurahSuccess extends SurahState {
  final SurahList surah;

  const SurahSuccess(this.surah);

  @override
  List<Object> get props => [surah];
}
