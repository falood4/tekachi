import 'package:flutter/material.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;

  TokenManager._internal();

  String? accessToken;
  String? refreshToken;
  int? userId;

  void setTokens(String access, String refresh, int uid) {
    accessToken = access;
    refreshToken = refresh;
    userId = uid;

    debugPrint('TOKEN GENERATED');
    debugPrint('Access Token: $access');
    debugPrint('Refresh Token: $refresh');
  }

  String? shareToken() => accessToken;
  String? shareRefreshToken() => refreshToken;

  void clear() {
    accessToken = null;
    refreshToken = null;
    userId = null;

    debugPrint('TOKENS CLEARED (logout / invalid)');
  }
}
