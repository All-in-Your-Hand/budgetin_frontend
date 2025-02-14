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
        // Allow redirects and specify which status codes are considered successful
        // TODO: Remove this when we have a proper way to handle redirects
        followRedirects: true,
        maxRedirects: 5,
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
            print('Request URL: ${options.uri}');
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
            if (response.isRedirect == true) {
              print('Redirect URL: ${response.realUri}');
            }
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print('Error: ${error.message}');
            print('Error Type: ${error.type}');
            print('Error Status Code: ${error.response?.statusCode}');
            print('Error Response: ${error.response?.data}');
            if (error.response?.isRedirect == true) {
              print('Redirect URL: ${error.response?.realUri}');
            }
          }

          // If we get a 302 status, retry the request once
          if (error.response?.statusCode == 302 &&
              error.requestOptions.extra['retried'] != true) {
            final options = error.requestOptions;
            options.extra['retried'] = true;

            try {
              final response = await dio.fetch(options);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }

          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
