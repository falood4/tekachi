import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';

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
  final TokenManager _tokenManager = TokenManager();
  final Dio _dio = DioClient().dio;

  void setCredentials(String email, String password) {
    _email = email;
  }

  void clearCredentials() {
    _email = null;
    _tokenManager.clear();
  }

  Future<void> setToken(
    String access_token,
    String refresh_token,
    int userID,
  ) async {
    _tokenManager.setTokens(access_token, refresh_token, userID);
  }

  int? shareUserId() {
    return _tokenManager.userId;
  }

  String? shareToken() {
    return _tokenManager.accessToken;
  }

  String? shareRefreshToken() {
    return _tokenManager.refreshToken;
  }

  String? shareEmail() {
    return _email;
  }

  bool isLoggedIn() {
    final token = _tokenManager.accessToken;
    return token != null &&
        token.isNotEmpty &&
        _email != null &&
        _email!.isNotEmpty;
  }

  static Future<Response> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioClient().dio.post(
        '$_baseUrl/register',
        data: jsonEncode({'email': email, 'password': password}),
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 409) {
        return response;
      }

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      final a_token = data['access_token'];
      final r_token = data['refresh_token'];
      final userID = data['id'];
      TokenManager().setTokens(a_token, r_token, userID);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/login',
        data: jsonEncode({"email": email.trim(), "password": password.trim()}),
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 401) {
        return response;
      }

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
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

  Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/change-password',
        data: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return response;
    } catch (e) {
      debugPrintStack(label: 'Password not changed due to error: $e');
      rethrow;
    }
  }

  Future<Response> logout() async {
    try {
      final response = await _dio.post(
        '$_baseUrl/logout',
        data: jsonEncode({"refresh_token": _tokenManager.refreshToken}),
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
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

  Future<Response> deleteUser() async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/delete',
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
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
