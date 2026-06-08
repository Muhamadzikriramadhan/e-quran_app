import '../../domain/entities/surah_entity.dart';
import '../../domain/entities/surah_detail_entity.dart';
import '../../domain/entities/tafsir_detail_entity.dart';
import '../../domain/repositories/surah_repository.dart';
import '../datasources/surah_remote_data_source.dart';

class SurahRepositoryImpl implements SurahRepository {
  final SurahRemoteDataSource remoteDataSource;

  SurahRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SurahListEntity> getSurahs(String url) async {
    return await remoteDataSource.getSurahs(url);
  }

  @override
  Future<SurahDetailEntity> getSurahDetail(String url) async {
    return await remoteDataSource.getSurahDetail(url);
  }

  @override
  Future<TafsirDetailEntity> getTafsirDetail(String url) async {
    return await remoteDataSource.getTafsirDetail(url);
  }
}
