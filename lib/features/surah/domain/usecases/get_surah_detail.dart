import 'package:equran_app/core/usecase/usecase.dart';
import '../entities/surah_detail_entity.dart';
import '../repositories/surah_repository.dart';

class GetSurahDetailUseCase implements UseCase<SurahDetailEntity, String> {
  final SurahRepository repository;

  GetSurahDetailUseCase(this.repository);

  @override
  Future<SurahDetailEntity> call(String url) async {
    return await repository.getSurahDetail(url);
  }
}
