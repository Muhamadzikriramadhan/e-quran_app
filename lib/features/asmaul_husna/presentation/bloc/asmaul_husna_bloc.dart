import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/asmaul_husna_remote_data_source.dart';
import '../../data/repositories/asmaul_husna_repository_impl.dart';
import '../../domain/usecases/get_asmaul_husna.dart';
import 'asmaul_husna_event.dart';
import 'asmaul_husna_state.dart';

class AsmaulHusnaBloc extends Bloc<AsmaulHusnaEvent, AsmaulHusnaState> {
  final GetAsmaulHusnaUseCase _getAsmaulHusnaUseCase;

  AsmaulHusnaBloc({GetAsmaulHusnaUseCase? getAsmaulHusnaUseCase})
      : _getAsmaulHusnaUseCase = getAsmaulHusnaUseCase ??
            GetAsmaulHusnaUseCase(
              AsmaulHusnaRepositoryImpl(
                remoteDataSource: AsmaulHusnaRemoteDataSourceImpl(
                  client: ApiClient(),
                ),
              ),
            ),
        super(AsmaulHusnaInitial()) {
    on<GetAsmaulHusna>((event, emit) async {
      try {
        emit(AsmaulHusnaLoading());
        final data = await _getAsmaulHusnaUseCase.call(event.url);
        emit(AsmaulHusnaSuccess(data));
      } catch (e) {
        emit(AsmaulHusnaFailed(e.toString()));
      }
    });
  }
}
