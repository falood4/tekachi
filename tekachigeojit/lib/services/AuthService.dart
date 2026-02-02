import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api/users';

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Stored credentials and token for logout
  String? _email;
  String? _password;
  String? _token;

  void setCredentials(String email, String password) {
    _email = email;
    _password = password;
  }

  void clearCredentials() {
    _email = null;
    _password = null;
    _token = null;
  }

  void setToken(String token) {
    _token = token;
  }

  String? shareToken() {
    return _token;
  }

  String? shareEmail() {
    return _email;
  }

  /// Build headers with Content-Type and Authorization
  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<http.Response> signup({
    required String email,
    required String password,
  }) {
    return http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<http.Response> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("http://10.0.2.2:8080/api/users/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      return response;
    } catch (e) {
      debugPrintStack(label: 'Login error: $e');
      rethrow;
    }
  }

  Future<http.Response> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: _headers(),
        body: jsonEncode({'email': _email, 'password': _password}),
      );

      if (response.statusCode == 200) {
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
        Uri.parse('$_baseUrl/delete/$_email'),
        headers: _headers(),
        body: jsonEncode({'email': _email, 'password': _password}),
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
}
