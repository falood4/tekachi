import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/ApiConfig.dart';
import 'package:dio/dio.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';

class FullTestService {
  static final FullTestService _instance = FullTestService._internal();

  factory FullTestService() {
    return _instance;
  }

  FullTestService._internal();

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

  final dio = DioClient().dio;
  final TokenManager _tokenManager = TokenManager();

  bool get _isAuthenticated {
    final token = _tokenManager.accessToken;
    return token != null && token.isNotEmpty;
  }

  Future<dynamic> saveAttempt() async {
    try {
      if (!_isAuthenticated) {
        return Future.error('User not authenticated');
      }

      final response = await dio.post(
        '$_baseUrl/new',
        data: {
          "userId": _tokenManager.userId,
          "aptAttemptId": getAptitudeid(),
          "techInterviewId": getTechChatId(),
          "hrInterviewId": getHrChatId(),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['message'] != null) {
          debugPrint(data['message'].toString());
        }
        return data;
      } else if (response.statusCode == 500) {
        return "Server error. Please try again";
      }
    } catch (e) {
      debugPrint('Attempt could not be saved: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchHistory(int user_id) async {
    try {
      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.get('$_baseUrl/attempts/$user_id');

      if (response.statusCode == 200) {
        final decoded = response.data;
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
        debugPrint('History fetched successfully');
        return <Map<String, dynamic>>[];
      } else if (response.statusCode == 500) {
        return <Map<String, dynamic>>[];
      }
    } on StateError {
      rethrow;
    } on DioException catch (e) {
      debugPrint('Failed to fetch history: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Failed to fetch history: $e');
      rethrow;
    }
    return <Map<String, dynamic>>[];
  }
}
