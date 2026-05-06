import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/ApiConfig.dart';
import 'package:dio/dio.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';

class HistoryService {
  static String get _baseUrl => '${ApiConfig.baseUrl}/history';
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() {
    return _instance;
  }

  HistoryService._internal();

  final dio = DioClient().dio;
  final TokenManager _tokenManager = TokenManager();

  bool get _isAuthenticated {
    final token = _tokenManager.accessToken;
    return token != null && token.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getAttemptHistory([int? user_id]) async {
    final uid = user_id ?? _tokenManager.userId;
    if (uid == null) {
      throw Exception('User ID not available');
    }

    try {
      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.get('$_baseUrl/$uid/attempts');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
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
    } on StateError {
      rethrow;
    } on DioException catch (e) {
      debugPrint('Could not get attempt history: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Could not get attempt history: $e');
      rethrow;
    }
  }

  Future<Response> saveAttempt(int user_id, int score) async {
    try {
      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.post(
        '$_baseUrl/newattempt',
        data: {"user": user_id, "correctAnswers": score},
      );

      return response;
    } on StateError {
      rethrow;
    } on DioException catch (e) {
      debugPrintStack(label: 'Attempt could not be saved: ${e.message}');
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
      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.post(
        '$_baseUrl/newanswer',
        data: {
          "attemptId": attemptId,
          "QId": questionId,
          "selectedOption": selectedOptionId,
        },
      );
      return response;
    } on StateError {
      rethrow;
    } on DioException catch (e) {
      debugPrint('Answer could not be saved: ${e.message}');
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
      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.get('$_baseUrl/$attempt_id');

      if (response.statusCode == 200) {
        debugPrint('Attempt history retrieved');
        final List<dynamic> data = response.data as List<dynamic>;
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
    } on StateError {
      rethrow;
    } on DioException catch (e) {
      debugPrint('Could not get attempt history: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Could not get attempt history: $e');
      return [];
    }
  }

  Future<Response> deleteAttempt() async {
    try {
      final user_id = _tokenManager.userId;
      if (user_id == null) {
        throw Exception('User ID not available');
      }

      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.delete('$_baseUrl/$user_id');

      return response;
    } on StateError {
      rethrow;
    } on DioException catch (e) {
      debugPrint('Could not delete attempt: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Could not delete attempt: $e');
      rethrow;
    }
  }
}
