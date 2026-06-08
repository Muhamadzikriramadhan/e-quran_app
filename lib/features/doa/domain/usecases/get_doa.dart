import 'package:equran_app/core/usecase/usecase.dart';
import '../entities/doa_entity.dart';
import '../repositories/doa_repository.dart';

class GetDoaUseCase implements UseCase<DoaEntity, String> {
  final DoaRepository repository;

  GetDoaUseCase(this.repository);

  @override
  Future<DoaEntity> call(String url) async {
    return await repository.getDoa(url);
  }
}
