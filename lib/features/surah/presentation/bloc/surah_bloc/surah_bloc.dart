import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equran_app/core/network/api_client.dart';
import 'package:equran_app/features/surah/data/datasources/surah_remote_data_source.dart';
import 'package:equran_app/features/surah/data/repositories/surah_repository_impl.dart';
import 'package:equran_app/features/surah/domain/usecases/get_list_surah.dart';
import 'surah_event.dart';
import 'surah_state.dart';

class SurahBloc extends Bloc<SurahEvent, SurahState> {
  final GetListSurahUseCase _getListSurahUseCase;

  SurahBloc({GetListSurahUseCase? getListSurahUseCase})
      : _getListSurahUseCase = getListSurahUseCase ??
            GetListSurahUseCase(
              SurahRepositoryImpl(
                remoteDataSource: SurahRemoteDataSourceImpl(
                  client: ApiClient(),
                ),
              ),
            ),
        super(SurahInitial()) {
    on<GetListSurah>((event, emit) async {
      try {
        emit(SurahLoading());
        final data = await _getListSurahUseCase.call(event.url);
        emit(SurahSuccess(data));
      } catch (e) {
        emit(SurahFailed(e.toString()));
      }
    });
  }
}
