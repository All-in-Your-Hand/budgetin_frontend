import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/constant/network_constants.dart';

class DioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstants.apiUrl,
        connectTimeout:
            const Duration(milliseconds: NetworkConstants.connectionTimeout),
        receiveTimeout:
            const Duration(milliseconds: NetworkConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Custom interceptor for minimal logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
                'Successfully fetched transactions for user ${response.requestOptions.uri.pathSegments.last}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('Error fetching transactions: ${error.message}');
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
