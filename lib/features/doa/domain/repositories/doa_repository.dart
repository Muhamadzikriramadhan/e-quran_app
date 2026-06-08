import '../entities/doa_entity.dart';

abstract class DoaRepository {
  Future<DoaEntity> getDoa(String url);
}
