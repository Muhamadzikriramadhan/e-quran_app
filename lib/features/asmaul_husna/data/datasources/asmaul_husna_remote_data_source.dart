import 'dart:convert';
import 'package:equran_app/core/network/api_client.dart';
import '../models/asmaul_husna_model.dart';

abstract class AsmaulHusnaRemoteDataSource {
  Future<AsmaulHusnaModel> getAsmaulHusna(String url);
}

class AsmaulHusnaRemoteDataSourceImpl implements AsmaulHusnaRemoteDataSource {
  final ApiClient client;

  AsmaulHusnaRemoteDataSourceImpl({required this.client});

  @override
  Future<AsmaulHusnaModel> getAsmaulHusna(String url) async {
    final response = await client.getMuslimApi(url);
    return AsmaulHusnaModel.fromJson(jsonDecode(response));
  }
}
