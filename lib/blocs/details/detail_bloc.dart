import 'dart:convert';

import 'package:equran_app/services/equran_services.dart';
import 'package:equran_app/models/surah_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailInitial()) {
    on<DetailEvent>((event, emit) async {
      if (event is DetailGetBySurahNumber) {
        try {
          emit(DetailLoading());

          final details = await EquranServices().hitEquran(event.url);

          SurahDetail data = SurahDetail.fromJson(jsonDecode(details));

          emit(DetailSuccess(data));
        } catch (e) {
          emit(DetailFailed(e.toString()));
        }
      }
    });
  }
}
