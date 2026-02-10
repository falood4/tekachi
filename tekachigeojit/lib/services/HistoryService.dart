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

  Future<http.Response> saveAttempt(int user_id, int score) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/newattempt'),
        headers: _headers(),
        body: jsonEncode({"user": user_id, "correctAnswers": score}),
      );

      return response;
    } catch (e) {
      debugPrintStack(label: 'Attempt could not be saved: $e');
      rethrow;
    }
  }

  Future<http.Response> saveAnswer({
    required int attemptId,
    required int questionId,
    required int selectedOptionId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/newanswer'),
        headers: _headers(),
        body: jsonEncode({
          "attemptId": attemptId,
          "QId": questionId,
          "selectedOption": selectedOptionId,
        }),
      );
      return response;
    } catch (e) {
      debugPrint('Answer could not be saved: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAttemptAnswers(int? attempt_id) async {
    if (attempt_id == null) {
      throw Exception('Attempt ID not available');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$attempt_id'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        debugPrint('Attempt history retrieved');
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) => {
                'qid': item['QId'],
                'qsn': item['QString'],
                'a_id': item['answerId'],
                'attemptId': item['attemptId'],
                'userChoice': item['selectedOptionText'],
                'correctAnswer': item['correctOptionText'],
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

  Future<http.Response> deleteAttempt() async {
    try {
      final user_id = AuthService().shareUserId();
      final response = await http.delete(
        Uri.parse('$_baseUrl/$user_id'),
        headers: _headers(),
      );

      return response;
    } catch (e) {
      debugPrint('Could not delete attempt: $e');
      rethrow;
    }
  }
}
