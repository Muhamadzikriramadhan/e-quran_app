import 'package:equran_app/core/usecase/usecase.dart';
import '../entities/asmaul_husna_entity.dart';
import '../repositories/asmaul_husna_repository.dart';

class GetAsmaulHusnaUseCase implements UseCase<AsmaulHusnaEntity, String> {
  final AsmaulHusnaRepository repository;

  GetAsmaulHusnaUseCase(this.repository);

  @override
  Future<AsmaulHusnaEntity> call(String url) async {
    return await repository.getAsmaulHusna(url);
  }
}
