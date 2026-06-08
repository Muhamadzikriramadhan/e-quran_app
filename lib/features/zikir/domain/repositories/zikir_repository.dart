import '../entities/zikir_entity.dart';

abstract class ZikirRepository {
  Future<ZikirEntity> getZikir(String url);
}
