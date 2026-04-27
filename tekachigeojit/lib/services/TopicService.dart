import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tekachigeojit/services/ApiConfig.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';

class Topicservice {
  static String get _baseUrl => ApiConfig.baseUrl;

  final dio = DioClient().dio;
  final TokenManager _tokenManager = TokenManager();
  bool get _isAuthenticated {
    final token = _tokenManager.accessToken;
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, int>> fetchTopicsMap(int low, int high) async {
    try {
      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.get('$_baseUrl/topics?low=$low&high=$high');

      if (response.statusCode == 200) {
        final decoded = response.data;
        return Map<String, int>.from(decoded);
      } else {
        throw Exception('Failed to load topics: HTTP ${response.statusCode}');
      }
    } on StateError {
      rethrow;
    } catch (e) {
      throw Exception('Failed to load topics: $e');
    }
  }

  Future<String> fetchTopicContent(int topicId) async {
    try {
      if (!_isAuthenticated) {
        throw StateError('User not authenticated');
      }

      final response = await dio.get('$_baseUrl/topics/$topicId');

      if (response.statusCode == 200) {
        String body = response.data.toString().trim();
        if (body.isEmpty) return 'No content found.';

        return body;
      }

      if (response.statusCode == 204 || response.statusCode == 404) {
        return 'Content not available.';
      }

      return 'Content not available.';
    } on StateError {
      rethrow;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 404 || statusCode == 204) {
        return 'Content not available.';
      }
      debugPrint('Topic content error: ${e.message}');
      return 'Something went wrong while loading this topic.';
    } catch (e) {
      debugPrint('Topic content error: $e');
      return 'Something went wrong while loading this topic.';
    }
  }
}
