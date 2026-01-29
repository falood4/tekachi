import 'dart:convert';
import 'package:flutter/services.dart';

class ContentLoader {
  static final Map<String, dynamic> _cache = {};

  static Future<Map<String, dynamic>> loadJson(String path) async {
    if (_cache.containsKey(path)) {
      return _cache[path];
    }

    final jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    _cache[path] = jsonData;
    return jsonData;
  }
}
