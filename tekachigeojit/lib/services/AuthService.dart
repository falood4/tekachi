import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/token_dio/DioClient.dart';
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';

import 'ApiConfig.dart';

class AuthService {
  static String get _baseUrl => '${ApiConfig.baseUrl}/users';

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final Dio _dio = DioClient().dio;
  final Dio _plainDio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status != null && status < 600,
    ),
  );

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
    TokenManager().clear();
  }

  Future<void> setToken(
    String access_token,
    String refresh_token,
    int userID,
  ) async {
    _access_token = access_token;
    _refresh_token = refresh_token;
    _userId = userID;
    TokenManager().setTokens(access_token, refresh_token, userID);
  }

  int? shareUserId() {
    return _userId ?? TokenManager().userId;
  }

  String? shareToken() {
    if (_access_token != null && _access_token!.isNotEmpty) {
      return _access_token;
    }
    return TokenManager().shareToken();
  }

  String? shareRefreshToken() {
    if (_refresh_token != null && _refresh_token!.isNotEmpty) {
      return _refresh_token;
    }
    return TokenManager().shareRefreshToken();
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

  Map<String, dynamic> _decodeJson(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String && data.isNotEmpty) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }

  Response _fallbackResponse(String path, Object error) {
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 500,
      data: {'error': error.toString()},
    );
  }

  static Future<Response> signup({
    required String email,
    required String password,
  }) async {
    try {
      final service = AuthService();
      final response = await service._plainDio.post(
        '$_baseUrl/register',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 409) {
        return response;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = service._decodeJson(response.data);
        final a_token = data['access_token'];
        final r_token = data['refresh_token'];
        final userID = data['id'];
        await service.setToken(a_token, r_token, userID);
      }

      return response;
    } on DioException catch (e) {
      return e.response ??
          AuthService()._fallbackResponse('$_baseUrl/register', e);
    } catch (e) {
      return AuthService()._fallbackResponse('$_baseUrl/register', e);
    }
  }

  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    final String path = '$_baseUrl/login';

    try {
      final response = await _plainDio.post(
        path,
        data: {"email": email.trim(), "password": password.trim()},
      );

      if (response.statusCode == 401) {
        return response;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _decodeJson(response.data);
        final a_token = data['access_token'];
        final r_token = data['refresh_token'];
        final userID = data['id'];
        await setToken(a_token, r_token, userID);
      }

      return response;
    } on DioException catch (e) {
      return e.response ?? _fallbackResponse(path, e);
    } catch (e) {
      debugPrintStack(label: 'Login error: $e');
      rethrow;
    }
  }

  Future<Response> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final String path = '$_baseUrl/change-password';

    try {
      return await _dio.post(
        path,
        data: {"oldPassword": oldPassword, "newPassword": newPassword},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        debugPrint('Password change failed: Unauthorized.');
        clearCredentials();
      }
      return e.response ?? _fallbackResponse(path, e);
    } catch (e) {
      debugPrintStack(label: 'Password not changed due to error: $e');
      rethrow;
    }
  }

  Future<Response> logout() async {
    final String path = '$_baseUrl/logout';
    try {
      final response = await _dio.post(
        path,
        data: {"refresh_token": shareRefreshToken()},
      );

      if (response.statusCode == 200) {
        clearCredentials();
        debugPrint('Logout Successful');
      }

      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        debugPrint('Logout failed: Unauthorized.');
        clearCredentials();
      }
      return e.response ?? _fallbackResponse(path, e);
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  Future<Response> deleteUser() async {
    final String path = '$_baseUrl/delete';
    try {
      final response = await _dio.delete(path);

      if (response.statusCode == 200) {
        clearCredentials();
        debugPrint('Account Deleted Successfully');
      }

      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        debugPrint('Account deletion failed: Unauthorized.');
        clearCredentials();
      }
      return e.response ?? _fallbackResponse(path, e);
    } catch (e) {
      debugPrint('Deletion error: $e');
      rethrow;
    }
  }

  Future<bool> tokenRefresh() async {
    try {
      final refreshToken = shareRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('Token refresh failed: missing refresh token.');
        return false;
      }

      final response = await _plainDio.post(
        '$_baseUrl/refresh',
        data: {'refresh_token': refreshToken, 'old_token': shareToken()},
      );

      if (response.statusCode == 200) {
        debugPrint('New tokens generated successfully');
        final data = _decodeJson(response.data);
        String a_token = data['access_token'];
        String r_token = data['refresh_token'];
        final userId = shareUserId();
        if (userId == null) {
          debugPrint('Token refresh failed: missing user id in session.');
          return false;
        }
        await setToken(a_token, r_token, userId);
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
