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

  // Stored credentials and token for logout
  String? get _token => AuthService().shareToken();
  int? get _userId => AuthService().shareUserId();
  late int conv_id;

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  void saveconvId(int id) {
    conv_id = id;
  }

  Future<String> startConversation(int persona_id) async {
    try {
      Map<String, String> msg_token = _headers();
      if (msg_token['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final reponse = await http.post(
        Uri.parse("$_baseUrl/start"),
        headers: msg_token,
        body: jsonEncode({'userId': _userId, 'personaId': persona_id}),
      );

      if (reponse.statusCode == 200) {
        final data = jsonDecode(reponse.body);
        String reply = data['greeting'];
        int conv_id = data['conversationId'];
        saveconvId(conv_id);
        debugPrint('convo id: $conv_id');

        return reply;
      } else if (reponse.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception(
          'Failed to start conversation: HTTP ${reponse.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to start conversation: $e');
    }
  }

  Future<String> newTechMessage(String userMsg) async {
    try {
      Map<String, String> msg_token = _headers();
      if (msg_token['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final reponse = await http.post(
        Uri.parse("$_baseUrl/$conv_id/tech/message"),
        headers: msg_token,
        body: jsonEncode({'content': userMsg}),
      );
      debugPrint('Message sent');

      if (reponse.statusCode == 200) {
        final data = jsonDecode(reponse.body);
        String reply = data['reply'];

        debugPrint('Received reply');
        return reply;
      } else if (reponse.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception('Failed to get reply: HTTP ${reponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get reply: $e');
    }
  }

  Future<String> newHrMessage(String userMsg) async {
    try {
      Map<String, String> msg_token = _headers();
      if (msg_token['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final reponse = await http.post(
        Uri.parse("$_baseUrl/$conv_id/hrmentor/message"),
        headers: msg_token,
        body: jsonEncode({'content': userMsg}),
      );

      if (reponse.statusCode == 200) {
        final data = jsonDecode(reponse.body);
        String reply = data['reply'];
        return reply;
      } else if (reponse.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception('Failed to get reply: HTTP ${reponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get reply: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getConversationHistory(int persona) async {
    try {
      Map<String, String> token = _headers();
      if (token['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      int? user_id = AuthService().shareUserId();

      final reponse = await http.get(
        Uri.parse("$_baseUrl/conversations/$user_id/$persona"),
        headers: token,
      );

      if (reponse.statusCode == 200) {
        final List<dynamic> data = jsonDecode(reponse.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else if (reponse.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception(
          'Failed to get conversation history: HTTP ${reponse.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get conversation history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getChatHistory(int conv_id) async {
    try {
      Map<String, String> token = _headers();
      if (token['Authorization'] == null) {
        return Future.error('User not authenticated');
      }

      final reponse = await http.get(
        Uri.parse("$_baseUrl/$conv_id/messages"),
        headers: token,
      );

      if (reponse.statusCode == 200) {
        final List<dynamic> data = jsonDecode(reponse.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else if (reponse.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception(
          'Failed to get conversation history: HTTP ${reponse.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get conversation history: $e');
    }
  }

  void clearChatHistory(int conv_id) async {
    try {
      Map<String, String> token = _headers();
      if (token['Authorization'] == null) {
        debugPrint('User not authenticated');
        return;
      }
      final reponse = await http.delete(
        Uri.parse("$_baseUrl/$conv_id/messages/clear"),
        headers: token,
      );

      if (reponse.statusCode == 200) {
        debugPrint('Conversation history cleared');
      } else if (reponse.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception(
          'Failed to clear conversation history: HTTP ${reponse.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to clear conversation history: $e');
    }
  }

  Future<void> clearConvoHistory(int persona) async {
    try {
      Map<String, String> token = _headers();
      if (token['Authorization'] == null) {
        debugPrint('User not authenticated');
        return;
      }

      int? user_id = AuthService().shareUserId();
      final reponse = await http.delete(
        Uri.parse("$_baseUrl/conversations/$user_id/$persona/clear"),
        headers: token,
      );

      if (reponse.statusCode == 200) {
        debugPrint('Conversation history cleared');
      } else if (reponse.statusCode == 500) {
        throw Exception('Server error. Please try later');
      } else {
        throw Exception(
          'Failed to clear conversation history: HTTP ${reponse.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to clear conversation history: $e');
    }
  }

  void clearConvId() {
    conv_id = 0;
  }
}
