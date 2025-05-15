part of 'doa_bloc.dart';

abstract class DoaEvent extends Equatable {

  const DoaEvent();

  @override
  List<Object> get props => [];
}

class GetDoa extends DoaEvent {
  final String url;

  const GetDoa(this.url);

  @override
  List<Object> get props => [url];
}
