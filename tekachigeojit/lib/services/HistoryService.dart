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

  Future<http.Response> storeqsn(
    int q_id,
    int _selectedOptionIndex,
    int attempt,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/aptitude/answers'),
        headers: _headers(),
        body: jsonEncode({
          'question': q_id,
          'selectedOption': _selectedOptionIndex,
          'attempt': attempt,
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Could not store question $e');
      rethrow;
    }
  }

  storeAttempt() {
    //to be implemented later
  }
}
