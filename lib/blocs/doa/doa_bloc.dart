import 'dart:convert';

import 'package:equran_app/models/doa_list.dart';
import 'package:equran_app/services/equran_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doa_event.dart';
part 'doa_state.dart';

class DoaBloc extends Bloc<DoaEvent, DoaState> {
  DoaBloc() : super(DoaInitial()) {
    on<DoaEvent>((event, emit) async {
      if (event is GetDoa) {
        try {
          emit(DoaLoading());

          final details = await EquranServices().hitMuslimApi(event.url);

          DoaList data = DoaList.fromJson(jsonDecode(details));

          emit(DoaSuccess(data));
        } catch (e) {
          emit(DoaFailed(e.toString()));
        }
      }
    });
  }
}
