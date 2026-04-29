import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/QuestionModel.dart';
import '../ApiConfig.dart';
import '../token_dio/DioClient.dart';

class QsnService {
  static String get _baseUrl => '${ApiConfig.baseUrl}/questions';
  static final QsnService _instance = QsnService._internal();

  factory QsnService() {
    return _instance;
  }

  QsnService._internal();

  final Dio _dio = DioClient().dio;

  Future<QuestionModel> getQuestion(int q_id) async {
    try {
      final response = await _dio.get('$_baseUrl/$q_id');

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data as String)
            : response.data;
        return QuestionModel.fromJson({
          'qId': data['qId'],
          'questionText': data['qsn'],
          'options': data['options'],
          'correctOptionId': data['correctOpId'],
        });
      }
      throw Exception('Failed to load question: ${response.statusCode}');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null) {
        throw Exception('Failed to load question: $status');
      }
      debugPrint('Could not get question $e');
      rethrow;
    } catch (e) {
      debugPrint('Could not get question $e');
      rethrow;
    }
  }
}
