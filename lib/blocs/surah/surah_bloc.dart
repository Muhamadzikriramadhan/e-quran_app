import 'dart:convert';

import 'package:equran_app/models/surah_list.dart';
import 'package:equran_app/models/tafsir_detail.dart';
import 'package:equran_app/services/equran_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'surah_event.dart';
part 'surah_state.dart';

class SurahBloc extends Bloc<SurahEvent, SurahState> {
  SurahBloc() : super(SurahInitial()) {
    on<SurahEvent>((event, emit) async {
      if (event is GetListSurah) {
        try {
          emit(SurahLoading());

          final Surahs = await EquranServices().hitEquran(event.url);

          SurahList data = SurahList.fromJson(jsonDecode(Surahs));

          emit(SurahSuccess(data));
        } catch (e) {
          emit(SurahFailed(e.toString()));
        }
      }
    });
  }
}
