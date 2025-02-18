import 'package:dio/dio.dart';

/// Handles Dio exceptions and returns a user-friendly error message.
String handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.cancel:
      return "Request to the server was cancelled.";
    case DioExceptionType.connectionTimeout:
      return "Connection timeout. Please check your internet.";
    case DioExceptionType.sendTimeout:
      return "Send timeout. Unable to connect to the server.";
    case DioExceptionType.receiveTimeout:
      return "Receive timeout. The server took too long to respond.";
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return _handleHttpError(statusCode, error.response?.data);
      }
      return "Unexpected server response.";
    case DioExceptionType.badCertificate:
      return "Invalid SSL certificate. Connection rejected.";
    case DioExceptionType.connectionError:
      return "No internet connection. Please check your network.";
    case DioExceptionType.unknown:
      return "An unknown error occurred. Please try again.";
  }
}

/// Handles HTTP-specific errors based on status codes.
String _handleHttpError(int statusCode, dynamic data) {
  switch (statusCode) {
    case 400:
      return "Bad request. Please try again.";
    case 401:
      return "Unauthorized. Please log in again.";
    case 403:
      return "Access forbidden. You don't have permission.";
    case 404:
      return "Resource not found. Please check the request.";
    case 409:
      return "Conflict error. The request conflicts with the current state.";
    case 413:
      return "Request entity too large.";
    case 422:
      return data["errors"] != null ? data["errors"].values.first[0] : "Validation failed. Please check your input.";
    case 429:
      return "Too many requests. Please try again later.";
    case 500:
      return "Server error. Please try again later.";
    default:
      return "Unexpected error (Code: $statusCode).";
  }
}
