import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<String> getEquran(String endpoint) async {
    try {
      debugPrint("URL $baseUrl$endpoint");
      final res = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Host': 'equran.id',
          'Accept': '*/*'
        },
      );
      debugPrint("RESPONSE ${res.body}");
      if (res.statusCode == 200) {
        return res.body;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getMuslimApi(String endpoint) async {
    try {
      debugPrint("URL $baseUrlMuslimApi$endpoint");
      final res = await _client.get(
        Uri.parse('$baseUrlMuslimApi$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Host': 'muslim-api-three.vercel.app',
          'Accept': '*/*'
        },
      );
      debugPrint("RESPONSE ${res.body}");
      if (res.statusCode == 200) {
        return res.body;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
