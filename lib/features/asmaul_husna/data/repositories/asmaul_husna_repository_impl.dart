import '../../domain/entities/asmaul_husna_entity.dart';
import '../../domain/repositories/asmaul_husna_repository.dart';
import '../datasources/asmaul_husna_remote_data_source.dart';

class AsmaulHusnaRepositoryImpl implements AsmaulHusnaRepository {
  final AsmaulHusnaRemoteDataSource remoteDataSource;

  AsmaulHusnaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AsmaulHusnaEntity> getAsmaulHusna(String url) async {
    return await remoteDataSource.getAsmaulHusna(url);
  }
}
