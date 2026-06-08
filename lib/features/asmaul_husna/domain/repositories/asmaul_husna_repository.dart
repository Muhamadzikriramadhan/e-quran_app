import '../entities/asmaul_husna_entity.dart';

abstract class AsmaulHusnaRepository {
  Future<AsmaulHusnaEntity> getAsmaulHusna(String url);
}
