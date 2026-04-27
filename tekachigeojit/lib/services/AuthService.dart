import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';

import 'ApiConfig.dart';

class AuthService {
  static String get _baseUrl => '${ApiConfig.baseUrl}/users';

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Stored credentials and token for logout
  String? _email;
  String? _access_token;
  String? _refresh_token;
  int? _userId;

  void setCredentials(String email, String password) {
    _email = email;
  }

  void clearCredentials() {
    _email = null;
    _access_token = null;
    _refresh_token = null;
    _userId = null;
  }

  Future<void> setToken(
    String access_token,
    String refresh_token,
    int userID,
  ) async {
    _access_token = access_token;
    _refresh_token = refresh_token;
    _userId = userID;
  }

  int? shareUserId() {
    return _userId;
  }

  String? shareToken() {
    return _access_token;
  }

  String? shareRefreshToken() {
    return _refresh_token;
  }

  String? shareEmail() {
    return _email;
  }

  bool isLoggedIn() {
    return _access_token != null &&
        _access_token!.isNotEmpty &&
        _email != null &&
        _email!.isNotEmpty;
  }

  /// Build headers with Content-Type and Authorization
  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_access_token != null && _access_token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_access_token';
    }
    return headers;
  }

  static Future<http.Response> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 409) {
        return http.Response('{"error": "Email already exists"}', 409);
      }

      final data = jsonDecode(response.body);
      final a_token = data['access_token'];
      final r_token = data['refresh_token'];
      final userID = data['id'];
      TokenManager().setTokens(a_token, r_token, userID);

      return response;
    } catch (e) {
      return http.Response('{"error": "Signup failed"}', 500);
    }
  }

  Future<http.Response> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$_baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      if (response.statusCode == 401) {
        return response;
      }

      final data = jsonDecode(response.body);
      final a_token = data['access_token'];
      final r_token = data['refresh_token'];
      final userID = data['id'];
      TokenManager().setTokens(a_token, r_token, userID);

      return response;
    } catch (e) {
      debugPrintStack(label: 'Login error: $e');
      rethrow;
    }
  }

  Future<http.Response> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse("$_baseUrl/change-password");

    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 401) {
        debugPrint('Password change failed: Unauthorized. Refreshing...');
        bool tokenFreshFlag = await tokenRefresh();
        if (tokenFreshFlag) {
          debugPrint('Token refreshed successfully. Retrying password change.');
          return await changePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
          );
        } else {
          debugPrint('Token refresh failed. Please log in again.');
          clearCredentials();
          return http.Response('{"error": "Unauthorized"}', 401);
        }
      }

      return response;
    } catch (e) {
      debugPrintStack(label: 'Password not changed due to error: $e');
      rethrow;
    }
  }

  Future<http.Response> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: _headers(),
        body: jsonEncode({"refresh_token": _refresh_token}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        clearCredentials();
        debugPrint('Logout Successful');
      } else if (response.statusCode == 401) {
        debugPrint('Logout failed: Unauthorized. Refreshing...');
        bool tokenFreshFlag = await tokenRefresh();
        if (tokenFreshFlag) {
          debugPrint('Token refreshed successfully. Retrying logout.');
          return await logout();
        } else {
          debugPrint('Token refresh failed. Please log in again.');
          clearCredentials();
          return http.Response('{"error": "Unauthorized"}', 401);
        }
      }

      return response;
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  Future<http.Response> deleteUser() async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/delete'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        clearCredentials();
        debugPrint('Account Deleted Successfully');
      } else if (response.statusCode == 401) {
        debugPrint('Account deletion failed: Unauthorized. Refreshing...');
        bool tokenFreshFlag = await tokenRefresh();
        if (tokenFreshFlag) {
          debugPrint(
            'Token refreshed successfully. Retrying account deletion.',
          );
          return await deleteUser();
        } else {
          debugPrint('Token refresh failed. Please log in again.');
          clearCredentials();
          return http.Response('{"error": "Unauthorized"}', 401);
        }
      }

      return response;
    } catch (e) {
      debugPrint('Deletion error: $e');
      rethrow;
    }
  }

  Future<bool> tokenRefresh() async {
    try {
      if (_refresh_token == null || _refresh_token!.isEmpty) {
        debugPrint('Token refresh failed: missing refresh token.');
        return false;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refresh_token': _refresh_token,
          'old_token': _access_token,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('New tokens generated successfully');
        final data = jsonDecode(response.body);
        String a_token = data['access_token'];
        String r_token = data['refresh_token'];
        if (_userId == null) {
          debugPrint('Token refresh failed: missing user id in session.');
          return false;
        }
        TokenManager().setTokens(a_token, r_token, _userId!);
        return true;
      } else if (response.statusCode == 401) {
        debugPrint('Token refresh failed: Unauthorized. Clearing credentials.');
        clearCredentials();
        return false;
      }

      return false;
    } catch (e) {
      debugPrint('Token generation failed: $e');
      rethrow;
    }
  }
}
