import 'package:dio/dio.dart';
import 'package:tekachigeojit/services/ApiConfig.dart';
import 'package:tekachigeojit/services/token_dio/AuthInterceptor.dart';
import 'package:tekachigeojit/services/token_dio/TokenManager.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AuthInterceptor(dio, TokenManager()));
  }
}
