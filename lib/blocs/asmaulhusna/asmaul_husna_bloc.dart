import 'dart:convert';

import 'package:equran_app/models/asmaul_husna.dart';
import 'package:equran_app/services/equran_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'asmaul_husna_event.dart';
part 'asmaul_husna_state.dart';

class AsmaulHusnaBloc extends Bloc<AsmaulHusnaEvent, AsmaulHusnaState> {
  AsmaulHusnaBloc() : super(AsmaulHusnaInitial()) {
    on<AsmaulHusnaEvent>((event, emit) async {
      if (event is GetAsmaulHusna) {
        try {
          emit(AsmaulHusnaLoading());

          final details = await EquranServices().hitMuslimApi(event.url);

          AsmaulHusna data = AsmaulHusna.fromJson(jsonDecode(details));

          emit(AsmaulHusnaSuccess(data));
        } catch (e) {
          emit(AsmaulHusnaFailed(e.toString()));
        }
      }
    });
  }
}
