import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tekachigeojit/services/AuthService.dart';

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

  Future<String> fetchTopicContent(int topicId) {
    return http
        .get(Uri.parse('$_baseUrl/topics/$topicId'), headers: _headers())
        .then((response) {
          if (response.statusCode == 200) {
            return response.body;
          } else {
            throw Exception('Failed to load topic content');
          }
        });
  }
}
