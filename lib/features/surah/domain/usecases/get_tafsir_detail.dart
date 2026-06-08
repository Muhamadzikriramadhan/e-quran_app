import 'package:equran_app/core/usecase/usecase.dart';
import '../entities/tafsir_detail_entity.dart';
import '../repositories/surah_repository.dart';

class GetTafsirDetailUseCase implements UseCase<TafsirDetailEntity, String> {
  final SurahRepository repository;

  GetTafsirDetailUseCase(this.repository);

  @override
  Future<TafsirDetailEntity> call(String url) async {
    return await repository.getTafsirDetail(url);
  }
}
