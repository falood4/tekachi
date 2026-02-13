import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tekachigeojit/services/AuthService.dart';
import 'package:flutter/foundation.dart';

class Topicservice {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  String? get _token => AuthService().shareToken();
  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<Map<String, int>> fetchTopicsMap(int low, int high) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/topics?low=$low&high=$high'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Convert dynamic map → Map<String, int>
      return Map<String, int>.from(decoded);
    } else {
      throw Exception('Failed to load topics');
    }
  }

  Future<String> fetchTopicContent(int topicId) async {
    final url = Uri.parse('$_baseUrl/topics/$topicId');

    try {
      final response = await http.get(url, headers: _headers());

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body.isEmpty) return 'No content found.';

        // Backend might return either plain text or JSON.
        try {
          final decoded = jsonDecode(body);
          if (decoded is Map) {
            final candidates = <dynamic>[
              decoded['content_text'],
              decoded['contentText'],
              decoded['content'],
              decoded['text'],
            ];
            for (final candidate in candidates) {
              if (candidate is String && candidate.trim().isNotEmpty) {
                return candidate;
              }
            }
          }
        } catch (_) {
          // Not JSON; treat as plain text.
        }

        return body;
      }

      if (response.statusCode == 204 || response.statusCode == 404) {
        return 'Content not available.';
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        return 'Please log in to view this content.';
      }

      debugPrint(
        'Topic content failed: ${response.statusCode} ${response.reasonPhrase} '
        'url=$url body=${response.body}',
      );
      return 'Failed to load topic content (HTTP ${response.statusCode}).';
    } on SocketException catch (e) {
      debugPrint('Topic content network error: $e url=$url');
      return 'Network error. Please check your connection and try again.';
    } catch (e) {
      debugPrint('Topic content error: $e url=$url');
      return 'Something went wrong while loading this topic.';
    }
  }
}
