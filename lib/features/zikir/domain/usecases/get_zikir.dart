import 'package:equran_app/core/usecase/usecase.dart';
import '../entities/zikir_entity.dart';
import '../repositories/zikir_repository.dart';

class GetZikirUseCase implements UseCase<ZikirEntity, String> {
  final ZikirRepository repository;

  GetZikirUseCase(this.repository);

  @override
  Future<ZikirEntity> call(String url) async {
    return await repository.getZikir(url);
  }
}
