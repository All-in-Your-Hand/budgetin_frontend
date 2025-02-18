import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/constant/network_constants.dart';
import '../utils/log/app_logger.dart';
import '../exceptions/network_exception.dart';
import 'error/dio_error_handler.dart';

/// Configuration class for setting up Dio HTTP client with custom interceptors and error handling.
/// This class follows the singleton pattern to ensure only one instance of Dio is created.
class DioConfig {
  const DioConfig._();

  /// Creates and configures a new [Dio] instance with default settings and custom interceptors.
  ///
  /// Returns a configured [Dio] instance with:
  /// - Base URL configuration
  /// - Timeout settings
  /// - Headers configuration
  /// - Custom logging interceptors
  /// - Error handling
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstants.apiUrl,
        connectTimeout: const Duration(milliseconds: NetworkConstants.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: NetworkConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status >= 200 && status < 400;
        },
      ),
    );

    // Custom interceptor for logging and error handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            AppLogger.debug(
              'Request',
              'Sending request to endpoint: ${options.uri}',
            );
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            AppLogger.debug(
              'Response',
              'Status Code: ${response.statusCode}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            AppLogger.error(
              'Network Error',
              'Type: ${error.type}\nStatus: ${error.response?.statusCode}\nMessage: ${handleDioError(error)}',
            );
          }

          // Transform DioException into our custom NetworkException
          final networkError = NetworkException(
            message: handleDioError(error),
            statusCode: error.response?.statusCode,
          );

          handler.reject(error.copyWith(error: networkError));
        },
      ),
    );

    return dio;
  }
}
