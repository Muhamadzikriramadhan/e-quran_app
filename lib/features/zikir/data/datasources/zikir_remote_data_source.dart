import 'dart:convert';
import 'package:equran_app/core/network/api_client.dart';
import '../models/zikir_model.dart';

abstract class ZikirRemoteDataSource {
  Future<ZikirModel> getZikir(String url);
}

class ZikirRemoteDataSourceImpl implements ZikirRemoteDataSource {
  final ApiClient client;

  ZikirRemoteDataSourceImpl({required this.client});

  @override
  Future<ZikirModel> getZikir(String url) async {
    final response = await client.getMuslimApi(url);
    return ZikirModel.fromJson(jsonDecode(response));
  }
}
