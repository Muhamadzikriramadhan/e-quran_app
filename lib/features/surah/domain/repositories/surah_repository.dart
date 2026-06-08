import '../entities/surah_entity.dart';
import '../entities/surah_detail_entity.dart';
import '../entities/tafsir_detail_entity.dart';

abstract class SurahRepository {
  Future<SurahListEntity> getSurahs(String url);
  Future<SurahDetailEntity> getSurahDetail(String url);
  Future<TafsirDetailEntity> getTafsirDetail(String url);
}
