import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/doa_remote_data_source.dart';
import '../../data/repositories/doa_repository_impl.dart';
import '../../domain/usecases/get_doa.dart';
import 'doa_event.dart';
import 'doa_state.dart';

class DoaBloc extends Bloc<DoaEvent, DoaState> {
  final GetDoaUseCase _getDoaUseCase;

  DoaBloc({GetDoaUseCase? getDoaUseCase})
      : _getDoaUseCase = getDoaUseCase ??
            GetDoaUseCase(
              DoaRepositoryImpl(
                remoteDataSource: DoaRemoteDataSourceImpl(
                  client: ApiClient(),
                ),
              ),
            ),
        super(DoaInitial()) {
    on<GetDoa>((event, emit) async {
      try {
        emit(DoaLoading());
        final data = await _getDoaUseCase.call(event.url);
        emit(DoaSuccess(data));
      } catch (e) {
        emit(DoaFailed(e.toString()));
      }
    });
  }
}
