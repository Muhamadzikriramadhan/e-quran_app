import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equran_app/core/network/api_client.dart';
import 'package:equran_app/features/surah/data/datasources/surah_remote_data_source.dart';
import 'package:equran_app/features/surah/data/repositories/surah_repository_impl.dart';
import 'package:equran_app/features/surah/domain/usecases/get_surah_detail.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetSurahDetailUseCase _getSurahDetailUseCase;

  DetailBloc({GetSurahDetailUseCase? getSurahDetailUseCase})
      : _getSurahDetailUseCase = getSurahDetailUseCase ??
            GetSurahDetailUseCase(
              SurahRepositoryImpl(
                remoteDataSource: SurahRemoteDataSourceImpl(
                  client: ApiClient(),
                ),
              ),
            ),
        super(DetailInitial()) {
    on<DetailGetBySurahNumber>((event, emit) async {
      try {
        emit(DetailLoading());
        final data = await _getSurahDetailUseCase.call(event.url);
        emit(DetailSuccess(data));
      } catch (e) {
        emit(DetailFailed(e.toString()));
      }
    });
  }
}
