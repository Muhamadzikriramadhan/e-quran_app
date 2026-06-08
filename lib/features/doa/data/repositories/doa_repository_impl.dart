import '../../domain/entities/doa_entity.dart';
import '../../domain/repositories/doa_repository.dart';
import '../datasources/doa_remote_data_source.dart';

class DoaRepositoryImpl implements DoaRepository {
  final DoaRemoteDataSource remoteDataSource;

  DoaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DoaEntity> getDoa(String url) async {
    return await remoteDataSource.getDoa(url);
  }
}
