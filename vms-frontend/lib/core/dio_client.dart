import 'package:dio/dio.dart';
import 'api_config.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class DioClient {
  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: ApiConfig.timeout,
            receiveTimeout: ApiConfig.timeout,
            sendTimeout: ApiConfig.timeout,
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null && _token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  static ApiException parseError(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final msg = data['message']?.toString();
        if (msg != null && msg.isNotEmpty) {
          return ApiException(msg, statusCode: status);
        }
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return ApiException(
          'Cannot connect to backend server at ${ApiConfig.baseUrl}. Please verify it is running.',
          statusCode: status,
        );
      }
      return ApiException(error.message ?? 'Network request failed', statusCode: status);
    }
    return ApiException(error.toString());
  }
}
