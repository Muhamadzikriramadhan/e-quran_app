import 'dart:convert';
import 'package:equran_app/core/network/api_client.dart';
import '../models/surah_list_model.dart';
import '../models/surah_detail_model.dart';
import '../models/tafsir_detail_model.dart';

abstract class SurahRemoteDataSource {
  Future<SurahListModel> getSurahs(String url);
  Future<SurahDetailModel> getSurahDetail(String url);
  Future<TafsirDetailModel> getTafsirDetail(String url);
}

class SurahRemoteDataSourceImpl implements SurahRemoteDataSource {
  final ApiClient client;

  SurahRemoteDataSourceImpl({required this.client});

  @override
  Future<SurahListModel> getSurahs(String url) async {
    final response = await client.getEquran(url);
    return SurahListModel.fromJson(jsonDecode(response));
  }

  @override
  Future<SurahDetailModel> getSurahDetail(String url) async {
    final response = await client.getEquran(url);
    return SurahDetailModel.fromJson(jsonDecode(response));
  }

  @override
  Future<TafsirDetailModel> getTafsirDetail(String url) async {
    final response = await client.getEquran(url);
    return TafsirDetailModel.fromJson(jsonDecode(response));
  }
}
