
import 'dart:convert';

import 'package:equran_app/utils/constantdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EquranServices {
  Future<String> hitEquran(String endpoint) async {
    try {
      debugPrint("URL $endpoint");
      final res = await http.get(
        Uri.parse('$base_url/$endpoint'),
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Host': 'equran.id',
          'Accept': '*/*'
        },
      );
      debugPrint("RESPONSE ${res.body}");
      if (res.statusCode == 200) {
        return res.body.toString();
      } else {
        throw jsonDecode(res.body);
      }
    } catch (e) {
      return e.toString();
    }
  }
}