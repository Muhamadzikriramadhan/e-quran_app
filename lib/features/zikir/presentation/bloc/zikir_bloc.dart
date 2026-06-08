import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/zikir_remote_data_source.dart';
import '../../data/repositories/zikir_repository_impl.dart';
import '../../domain/usecases/get_zikir.dart';
import 'zikir_event.dart';
import 'zikir_state.dart';

class ZikirBloc extends Bloc<ZikirEvent, ZikirState> {
  final GetZikirUseCase _getZikirUseCase;

  ZikirBloc({GetZikirUseCase? getZikirUseCase})
      : _getZikirUseCase = getZikirUseCase ??
            GetZikirUseCase(
              ZikirRepositoryImpl(
                remoteDataSource: ZikirRemoteDataSourceImpl(
                  client: ApiClient(),
                ),
              ),
            ),
        super(ZikirInitial()) {
    on<GetZikir>((event, emit) async {
      try {
        emit(ZikirLoading());
        final data = await _getZikirUseCase.call(event.url);
        emit(ZikirSuccess(data));
      } catch (e) {
        emit(ZikirFailed(e.toString()));
      }
    });
  }
}
