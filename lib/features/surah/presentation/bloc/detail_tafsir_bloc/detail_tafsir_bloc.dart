import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equran_app/core/network/api_client.dart';
import 'package:equran_app/features/surah/data/datasources/surah_remote_data_source.dart';
import 'package:equran_app/features/surah/data/repositories/surah_repository_impl.dart';
import 'package:equran_app/features/surah/domain/usecases/get_tafsir_detail.dart';
import 'detail_tafsir_event.dart';
import 'detail_tafsir_state.dart';

class DetailTafsirBloc extends Bloc<DetailTafsirEvent, DetailTafsirState> {
  final GetTafsirDetailUseCase _getTafsirDetailUseCase;

  DetailTafsirBloc({GetTafsirDetailUseCase? getTafsirDetailUseCase})
      : _getTafsirDetailUseCase = getTafsirDetailUseCase ??
            GetTafsirDetailUseCase(
              SurahRepositoryImpl(
                remoteDataSource: SurahRemoteDataSourceImpl(
                  client: ApiClient(),
                ),
              ),
            ),
        super(DetailTafsirInitial()) {
    on<DetailTafsirGetBySurahNumber>((event, emit) async {
      try {
        emit(DetailTafsirLoading());
        final data = await _getTafsirDetailUseCase.call(event.url);
        emit(DetailTafsirSuccess(data));
      } catch (e) {
        emit(DetailTafsirFailed(e.toString()));
      }
    });
  }
}
