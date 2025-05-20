import 'dart:convert';

import 'package:equran_app/services/equran_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/zikir_list.dart';

part 'zikir_event.dart';
part 'zikir_state.dart';

class ZikirBloc extends Bloc<ZikirEvent, ZikirState> {
  ZikirBloc() : super(ZikirInitial()) {
    on<ZikirEvent>((event, emit) async {
      if (event is GetZikir) {
        try {
          emit(ZikirLoading());

          final details = await EquranServices().hitMuslimApi(event.url);

          ZikirList data = ZikirList.fromJson(jsonDecode(details));

          emit(ZikirSuccess(data));
        } catch (e) {
          emit(ZikirFailed(e.toString()));
        }
      }
    });
  }
}
