import 'package:equran_app/core/usecase/usecase.dart';
import '../entities/surah_entity.dart';
import '../repositories/surah_repository.dart';

class GetListSurahUseCase implements UseCase<SurahListEntity, String> {
  final SurahRepository repository;

  GetListSurahUseCase(this.repository);

  @override
  Future<SurahListEntity> call(String url) async {
    return await repository.getSurahs(url);
  }
}
