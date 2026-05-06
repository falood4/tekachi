import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/QuestionModel.dart';
import '../ApiConfig.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';

class QsnService {
  static String get _baseUrl => '${ApiConfig.baseUrl}/questions';
  static final QsnService _instance = QsnService._internal();

  factory QsnService() {
    return _instance;
  }

  QsnService._internal();

  final dio = DioClient().dio;
  final TokenManager _tokenManager = TokenManager();

  bool get _isAuthenticated {
    final token = _tokenManager.accessToken;
    return token != null && token.isNotEmpty;
  }

  Future<QuestionModel> getQuestion(int q_id) async {
    try {
      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.get('$_baseUrl/$q_id');

      if (response.statusCode == 200) {
        final data = response.data;
        return QuestionModel.fromJson({
          'qId': data['qId'],
          'questionText': data['qsn'],
          'options': data['options'],
          'correctOptionId': data['correctOpId'],
        });
      } else {
        throw Exception('Failed to load question: ${response.statusCode}');
      }
    } on StateError {
      rethrow;
    } on DioException catch (e) {
      debugPrint('Could not get question ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Could not get question $e');
      rethrow;
    }
  }
}
