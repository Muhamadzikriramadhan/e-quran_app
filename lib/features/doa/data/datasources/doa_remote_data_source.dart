import 'dart:convert';
import 'package:equran_app/core/network/api_client.dart';
import '../models/doa_model.dart';

abstract class DoaRemoteDataSource {
  Future<DoaModel> getDoa(String url);
}

class DoaRemoteDataSourceImpl implements DoaRemoteDataSource {
  final ApiClient client;

  DoaRemoteDataSourceImpl({required this.client});

  @override
  Future<DoaModel> getDoa(String url) async {
    final response = await client.getMuslimApi(url);
    return DoaModel.fromJson(jsonDecode(response));
  }
}
