import 'dart:convert';

import 'package:equran_app/models/tafsir_detail.dart';
import 'package:equran_app/services/equran_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_tafsir_event.dart';
part 'detail_tafsir_state.dart';

class DetailTafsirBloc extends Bloc<DetailTafsirEvent, DetailTafsirState> {
  DetailTafsirBloc() : super(DetailTafsirInitial()) {
    on<DetailTafsirEvent>((event, emit) async {
      if (event is DetailTafsirGetBySurahNumber) {
        try {
          emit(DetailTafsirLoading());

          final DetailTafsirs = await EquranServices().hitEquran(event.url);

          TafsirDetail data = TafsirDetail.fromJson(jsonDecode(DetailTafsirs));

          emit(DetailTafsirSuccess(data));
        } catch (e) {
          emit(DetailTafsirFailed(e.toString()));
        }
      }
    });
  }
}
