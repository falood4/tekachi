import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tekachigeojit/services/AuthService.dart';

class FullTestService {
  static final FullTestService _instance = FullTestService._internal();

  factory FullTestService() {
    return _instance;
  }

  FullTestService._internal();

  //IDs
  int? _aptitudeid;
  int? _tech_chat_id;
  int? _hr_chat_id;

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
  }

  void setTechnicalVerdict(String verdict) {
    _technicalVerdict = verdict;
  }

  void setHRVerdict(String verdict) {
    _hrVerdict = verdict;
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

  final _baseUrl = "http://localhost:8080/placement";

  String? get _token => AuthService().shareToken();
  int? user_id = AuthService().shareUserId();

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<dynamic> saveAttempt() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/new'),
        headers: _headers(),
        body: jsonEncode({
          "userId": user_id,
          "aptAttemptId": getAptitudeid(),
          "techInterviewId": getTechChatId(),
          "hrInterviewId": getHrChatId(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(data['message']);

        return data;
      } else if (response.statusCode == 500) {
        return "Server error. Please try again";
      }
    } catch (e) {
      debugPrint('Attempt could not be saved: $e');
      rethrow;
    }
  }
}
