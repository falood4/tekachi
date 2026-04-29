import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/AuthService.dart';
import 'package:tekachigeojit/services/ApiConfig.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';

class FullTestService {
  static final FullTestService _instance = FullTestService._internal();

  factory FullTestService() {
    return _instance;
  }

  FullTestService._internal();

  final Dio _dio = DioClient().dio;

  //IDs
  int? _aptitudeid;
  int? _tech_chat_id = null;
  int? _hr_chat_id = null;

  void setAptitudeid(int? id) {
    _aptitudeid = id; //set in QuizResult
  }

  void setTechChatId(int? id) {
    _tech_chat_id = id; //set in ChatInterview
  }

  void setHrChatId(int? id) {
    _hr_chat_id = id; //set in ChatInterview
  }

  int? getAptitudeid() {
    return _aptitudeid;
  }

  int? getTechChatId() {
    return _tech_chat_id;
  }

  int? getHrChatId() {
    return _hr_chat_id;
  }

  //Results

  int? _aptitudeScore;
  String? _technicalVerdict;
  String? _hrVerdict;

  void setAptitudeScore(int score) {
    _aptitudeScore = score;
    debugPrint('Aptitude score set to: $score');
  }

  void setTechnicalVerdict(String verdict) {
    _technicalVerdict = verdict;
    debugPrint('Technical verdict set to: $verdict');
  }

  void setHRVerdict(String verdict) {
    _hrVerdict = verdict;
    debugPrint('HR verdict set to: $verdict');
  }

  int getAptitudeScore() {
    return _aptitudeScore ?? 0;
  }

  String getTechnicalVerdict() {
    return _technicalVerdict ?? 'Not evaluated';
  }

  String getHRVerdict() {
    return _hrVerdict ?? 'Not evaluated';
  }

  late final String _baseUrl = '${ApiConfig.baseUrl}/placement';

  int? user_id = AuthService().shareUserId();

  Future<dynamic> saveAttempt() async {
    try {
      final response = await _dio.post(
        '$_baseUrl/new',
        data: {
          "userId": user_id,
          "aptAttemptId": getAptitudeid(),
          "techInterviewId": getTechChatId(),
          "hrInterviewId": getHrChatId(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = response.data;
        final data = decoded is String
            ? jsonDecode(decoded) as Map<String, dynamic>
            : decoded as Map<String, dynamic>;
        debugPrint(data['message']);

        return data;
      } else if (response.statusCode == 500) {
        return "Server error. Please try again";
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        return "Server error. Please try again";
      }
      debugPrint('Attempt could not be saved: $e');
      rethrow;
    } catch (e) {
      debugPrint('Attempt could not be saved: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchHistory(int user_id) async {
    try {
      final response = await _dio.get('$_baseUrl/attempts/$user_id');

      if (response.statusCode == 200) {
        final decoded = response.data is String
            ? jsonDecode(response.data as String)
            : response.data;
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
        debugPrint('History fetched successfully');
        return <Map<String, dynamic>>[];
      } else if (response.statusCode == 500) {
        return <Map<String, dynamic>>[];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        return <Map<String, dynamic>>[];
      }
      debugPrint('Failed to fetch history: $e');
      rethrow;
    } catch (e) {
      debugPrint('Failed to fetch history: $e');
      rethrow;
    }
    return <Map<String, dynamic>>[];
  }

  Future<Response> deleteAttempts(int userId) async {
    try {
      return await _dio.delete('$_baseUrl/attempts/$userId');
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      debugPrint('Failed to delete attempts: $e');
      rethrow;
    } catch (e) {
      debugPrint('Failed to delete attempts: $e');
      rethrow;
    }
  }
}
