import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/AuthService.dart';
import 'package:tekachigeojit/services/ApiConfig.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';

class HistoryService {
  static String get _baseUrl => '${ApiConfig.baseUrl}/history';
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() {
    return _instance;
  }

  HistoryService._internal();

  final Dio _dio = DioClient().dio;

  Future<List<Map<String, dynamic>>> getAttemptHistory([int? user_id]) async {
    final uid = user_id ?? AuthService().shareUserId();
    if (uid == null) {
      throw Exception('User ID not available');
    }

    try {
      final response = await _dio.get('$_baseUrl/$uid/attempts');

      if (response.statusCode == 200) {
        final decoded = response.data is String
            ? jsonDecode(response.data as String)
            : response.data;
        final List<dynamic> data = decoded as List<dynamic>;
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
      }
      throw Exception('${response.statusCode}');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null) {
        debugPrint('Could not get attempt history: HTTP $status');
        rethrow;
      }
      debugPrint('Could not get attempt history: $e');
      rethrow;
    } catch (e) {
      debugPrint('Could not get attempt history: $e');
      rethrow;
    }
  }

  Future<Response> saveAttempt(int user_id, int score) async {
    try {
      return await _dio.post(
        '$_baseUrl/newattempt',
        data: {"user": user_id, "correctAnswers": score},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      debugPrintStack(label: 'Attempt could not be saved: $e');
      rethrow;
    } catch (e) {
      debugPrintStack(label: 'Attempt could not be saved: $e');
      rethrow;
    }
  }

  Future<Response> saveAnswer({
    required int attemptId,
    required int questionId,
    required int selectedOptionId,
  }) async {
    try {
      return await _dio.post(
        '$_baseUrl/newanswer',
        data: {
          "attemptId": attemptId,
          "QId": questionId,
          "selectedOption": selectedOptionId,
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      debugPrint('Answer could not be saved: $e');
      rethrow;
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
      final response = await _dio.get('$_baseUrl/$attempt_id');

      if (response.statusCode == 200) {
        debugPrint('Attempt history retrieved');
        final decoded = response.data is String
            ? jsonDecode(response.data as String)
            : response.data;
        final List<dynamic> data = decoded as List<dynamic>;
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
      }
      throw Exception('${response.statusCode}');
    } on DioException catch (e) {
      debugPrint('Could not get attempt history: $e');
      return [];
    } catch (e) {
      debugPrint('Could not get attempt history: $e');
      return [];
    }
  }

  Future<Response> deleteAttempt() async {
    try {
      final user_id = AuthService().shareUserId();
      if (user_id == null) {
        throw Exception('User ID not available');
      }
      return await _dio.delete('$_baseUrl/$user_id');
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      debugPrint('Could not delete attempt: $e');
      rethrow;
    } catch (e) {
      debugPrint('Could not delete attempt: $e');
      rethrow;
    }
  }
}
