import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'AuthService.dart';

class Chatservice {
  static const String _baseUrl = 'http://10.0.2.2:8080/chat';

  static final Chatservice _instance = Chatservice._internal();

  factory Chatservice() {
    return _instance;
  }

  Chatservice._internal();

  String? get _token => AuthService().shareToken();
  int? get _userId => AuthService().shareUserId();
  int _convId = 0;

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  void _saveConvId(int id) {
    _convId = id;
  }

  Future<String> startConversation(int personaId) async {
    try {
      final requestHeaders = _headers();
      if (requestHeaders['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final response = await http.post(
        Uri.parse("$_baseUrl/start"),
        headers: requestHeaders,
        body: jsonEncode({'userId': _userId, 'personaId': personaId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String reply = data['greeting'];
        final int convId = data['conversationId'];
        _saveConvId(convId);

        return reply;
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception(
          'Failed to start conversation: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to start conversation: $e');
    }
  }

  Future<String> newTechMessage(String userMsg) async {
    try {
      final requestHeaders = _headers();
      if (requestHeaders['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final response = await http.post(
        Uri.parse("$_baseUrl/$_convId/tech/message"),
        headers: requestHeaders,
        body: jsonEncode({'content': userMsg}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String reply = data['reply'];
        return reply;
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception('Failed to get reply: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get reply: $e');
    }
  }

  Future<String> newHrMessage(String userMsg) async {
    try {
      final requestHeaders = _headers();
      if (requestHeaders['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final response = await http.post(
        Uri.parse("$_baseUrl/$_convId/hrmentor/message"),
        headers: requestHeaders,
        body: jsonEncode({'content': userMsg}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String reply = data['reply'];
        return reply;
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception('Failed to get reply: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get reply: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getConversationHistory(int persona) async {
    try {
      final requestHeaders = _headers();
      if (requestHeaders['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final int? userId = AuthService().shareUserId();

      final response = await http.get(
        Uri.parse("$_baseUrl/conversations/$userId/$persona"),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception(
          'Failed to get conversation history: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get conversation history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getChatHistory(int convId) async {
    try {
      final requestHeaders = _headers();
      if (requestHeaders['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final response = await http.get(
        Uri.parse("$_baseUrl/$convId/messages"),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception(
          'Failed to get conversation history: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get conversation history: $e');
    }
  }

  Future<void> clearChatHistory(int convId) async {
    final requestHeaders = _headers();
    if (requestHeaders['Authorization'] == null) {
      debugPrint('User not authenticated');
      return;
    }
    final response = await http.delete(
      Uri.parse("$_baseUrl/$convId/messages/clear"),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      debugPrint('Conversation history cleared');
    } else if (response.statusCode == 500) {
      throw Exception('Server error. Please try later');
    } else {
      throw Exception(
        'Failed to clear conversation history: HTTP ${response.statusCode}',
      );
    }
  }

  Future<void> clearConvoHistory(int persona) async {
    final requestHeaders = _headers();
    if (requestHeaders['Authorization'] == null) {
      debugPrint('User not authenticated');
      return;
    }

    final int? userId = AuthService().shareUserId();
    final response = await http.delete(
      Uri.parse("$_baseUrl/conversations/$userId/$persona/clear"),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      debugPrint('Conversation history cleared');
    } else if (response.statusCode == 500) {
      throw Exception('Server error. Please try later');
    } else {
      throw Exception(
        'Failed to clear conversation history: HTTP ${response.statusCode}',
      );
    }
  }

  void clearConvId() {
    _convId = 0;
  }
}
