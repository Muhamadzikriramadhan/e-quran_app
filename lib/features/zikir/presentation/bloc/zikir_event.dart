import 'package:equatable/equatable.dart';

abstract class ZikirEvent extends Equatable {
  const ZikirEvent();

  @override
  List<Object> get props => [];
}

class GetZikir extends ZikirEvent {
  final String url;

  const GetZikir(this.url);

  @override
  List<Object> get props => [url];
}
