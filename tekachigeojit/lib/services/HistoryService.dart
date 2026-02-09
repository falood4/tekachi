import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/AuthService.dart';

class HistoryService {
  static const String _baseUrl = 'http://10.0.2.2:8080/history';
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() {
    return _instance;
  }

  HistoryService._internal();

  String? get _token => AuthService().shareToken();

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<List<Map<String, dynamic>>> getAttemptHistory([int? user_id]) async {
    final uid = user_id ?? AuthService().shareUserId();
    if (uid == null) {
      throw Exception('User ID not available');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$uid/attempts'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) => {
                'attemptId': item['attemptId'],
                'attemptedOn': item['attemptedOn'],
                'score': item['score'],
                'userId': item['userId'],
              },
            )
            .toList();
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Could not get attempt history: $e');
      rethrow;
    }
  }
}
