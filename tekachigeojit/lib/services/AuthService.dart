import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      AuthService().setToken(a_token, r_token, userID);

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
      setToken(a_token, r_token, userID);

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
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        clearCredentials();
        debugPrint('Logout Successful');
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
      }

      return response;
    } catch (e) {
      debugPrint('Deletion error: $e');
      rethrow;
    }
  }

  Future<http.Response> tokenRefresh() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        clearCredentials();
        debugPrint('New tokens generated successfully');
      }

      return response;
    } catch (e) {
      debugPrint('Token generation failed: $e');
      rethrow;
    }
  }
}
