import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'TokenManager.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenManager tokenManager;

  bool _isRefreshing = false;
  final List<Function> _queue = [];

  AuthInterceptor(this.dio, this.tokenManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenManager.accessToken;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    debugPrint('⚠️ TOKEN EXPIRED (401 received)');

    final request = err.requestOptions;

    if (request.extra['retry'] == true) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      _queue.add(() async {
        final response = await _retry(request);
        handler.resolve(response);
      });
      return;
    }

    _isRefreshing = true;

    try {
      final newTokens = await _refreshToken();
      debugPrint('TOKEN REFRESH SUCCESS');
      tokenManager.setTokens(
        newTokens['access'],
        newTokens['refresh'],
        tokenManager.userId ?? 0,
      );

      final response = await _retry(request);

      for (var req in _queue) {
        await req();
      }
      _queue.clear();

      handler.resolve(response);
    } catch (e) {
      tokenManager.clear();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response> _retry(RequestOptions request) {
    request.extra['retry'] = true;

    return dio.fetch(
      request..headers['Authorization'] = 'Bearer ${tokenManager.accessToken}',
    );
  }

  Future<Map<String, dynamic>> _refreshToken() async {
    final refreshDio = Dio(); // IMPORTANT: separate instance

    final response = await refreshDio.post(
      '${dio.options.baseUrl}/users/refresh',
      data: {
        'refresh_token': tokenManager.refreshToken,
        'old_token': tokenManager.accessToken,
      },
    );

    return {
      'access': response.data['access_token'],
      'refresh': response.data['refresh_token'],
    };
  }
}
