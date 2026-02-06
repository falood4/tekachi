import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AuthService.dart';

class QsnService {
  static const String _baseUrl = 'http://10.0.2.2:8080/questions';
  static final QsnService _instance = QsnService._internal();

  factory QsnService() {
    return _instance;
  }

  QsnService._internal();

  String? get _token => AuthService().shareToken();

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> getqsn(int q_id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$q_id'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final options = (data['options'] as List)
            .map((option) => option['op'] as String)
            .toList();
        return {
          'questionText': data['qsn'],
          'correctAnswerIndex': data['qCorrectOption'],
          'options': options,
        };
      } else {
        throw Exception('Failed to load question: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Could not get question $e');
      rethrow;
    }
  }

}
