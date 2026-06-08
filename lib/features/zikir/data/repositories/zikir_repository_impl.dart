import '../../domain/entities/zikir_entity.dart';
import '../../domain/repositories/zikir_repository.dart';
import '../datasources/zikir_remote_data_source.dart';

class ZikirRepositoryImpl implements ZikirRepository {
  final ZikirRemoteDataSource remoteDataSource;

  ZikirRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ZikirEntity> getZikir(String url) async {
    return await remoteDataSource.getZikir(url);
  }
}
