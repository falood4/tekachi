import 'package:flutter/cupertino.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';
import 'ApiConfig.dart';

class Chatservice {
  static String get _baseUrl => '${ApiConfig.baseUrl}/chat';

  static final Chatservice _instance = Chatservice._internal();

  factory Chatservice() {
    return _instance;
  }

  Chatservice._internal();

  int? _convId;

  final dio = DioClient().dio;
  final TokenManager _tokenManager = TokenManager();

  bool get _isAuthenticated {
    final token = _tokenManager.accessToken;
    return token != null && token.isNotEmpty;
  }

  void _saveConvId(int id) {
    _convId = id;
  }

  int? shareConvId() {
    return _convId;
  }

  Future<String> startConversation(int personaId) async {
    try {
      if (!_isAuthenticated) {
        debugPrint('User not authenticated');
        return Future.error('User not authenticated');
      }

      final response = await dio.post(
        '$_baseUrl/start',
        data: {'userId': _tokenManager.userId, 'personaId': personaId},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final String reply = data['greeting'];
        final int convId = data['conversationId'];
        _saveConvId(convId);

        return reply;
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
      if (!_isAuthenticated) {
        return Future.error('User not authenticated');
      }
      if (_convId == null) {
        throw Exception('No active conversation. Please start a new session.');
      }

      final response = await dio.post(
        '$_baseUrl/$_convId/tech/message',
        data: {'content': userMsg},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final String reply = data['reply'];
        return reply;
      } else {
        throw Exception('Failed to get reply: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get reply: $e');
    }
  }

  Future<String> newHrMessage(String userMsg) async {
    try {
      if (!_isAuthenticated) {
        return Future.error('User not authenticated');
      }
      if (_convId == null) {
        throw Exception('No active conversation. Please start a new session.');
      }

      final response = await dio.post(
        '$_baseUrl/$_convId/hrmentor/message',
        data: {'content': userMsg},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final String reply = data['reply'];
        return reply;
      } else {
        throw Exception('Failed to get reply: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get reply: $e');
    }
  }

  Future<String> getVerdict() async {
    try {
      if (!_isAuthenticated) {
        return Future.error('User not authenticated');
      }
      if (_convId == null) {
        throw Exception('No active conversation. Please start a new session.');
      }

      final response = await dio.post(
        '$_baseUrl/$_convId/messages/verdict',
        data: {'content': 'thank you'},
      );

      if (response.statusCode == 200) {
        debugPrint('response: ${response.data}');
        final verdict = response.data.toString();
        return verdict;
      } else {
        throw Exception('Failed to get verdict: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get verdict: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getConversationHistory(int persona) async {
    try {
      if (!_isAuthenticated) {
        return Future.error('User not authenticated');
      }

      final int? userId = _tokenManager.userId;
      if (userId == null) {
        return Future.error('User not authenticated');
      }

      final response = await dio.get(
        '$_baseUrl/conversations/$userId/$persona',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
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

  Future<List<Map<String, dynamic>>> getChatHistory(int? convId) async {
    try {
      if (!_isAuthenticated) {
        return Future.error('User not authenticated');
      }

      final response = await dio.get('$_baseUrl/$convId/messages');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
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
    if (!_isAuthenticated) {
      debugPrint('User not authenticated');
      return;
    }
    final response = await dio.delete('$_baseUrl/$convId/messages/clear');

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
    if (!_isAuthenticated) {
      debugPrint('User not authenticated');
      return;
    }

    final int? userId = _tokenManager.userId;
    if (userId == null) {
      debugPrint('User not authenticated');
      return;
    }
    final response = await dio.delete(
      '$_baseUrl/conversations/$userId/$persona/clear',
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
    _convId = null;
  }
}
