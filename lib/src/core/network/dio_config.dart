import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/constant/network_constants.dart';

class DioConfig {
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

    // Custom interceptor for detailed logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('Sending request to endpoint: ${options.uri}');
            // print('Request Headers: ${options.headers}');
            //print('Request Data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('Response Status Code: ${response.statusCode}');
            // print('Response Headers: ${response.headers}');
            // print('Response Data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print('Error: ${error.message}');
            print('Error Type: ${error.type}');
            print('Error Status Code: ${error.response?.statusCode}');
            print('Error Response: ${error.response?.data}');
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
