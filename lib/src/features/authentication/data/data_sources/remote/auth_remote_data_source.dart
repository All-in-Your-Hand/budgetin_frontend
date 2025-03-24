// import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../domain/models/auth_request_model.dart';
import '../../../domain/models/auth_response_model.dart';
import '../../../../../core/utils/constant/network_constants.dart';
import '../../../../../core/exceptions/network_exception.dart';
import '../../../../../core/network/error/dio_error_handler.dart';

/// Remote data source interface for authentication-related API operations.
/// Handles all network requests related to user authentication including
/// registration, login, and password management.
abstract class AuthRemoteDataSource {
  /// Creates a new user account with the provided details.
  ///
  /// Returns [AuthResponseModel] on successful registration.
  /// Throws [NetworkException] if the registration fails.
  /// [request] contains the user registration details including name, email, and password.
  Future<Either<NetworkException, AuthResponseModel>> createUser(AuthRequestModel request);

  /// Login a user with the provided details.
  ///
  /// Returns [AuthResponseModel] on successful login.
  /// Throws [NetworkException] if the login fails.
  /// [request] contains the user login details including email and password.
  Future<Either<NetworkException, AuthResponseModel>> loginUser(AuthRequestModel request);
}

/// Implementation of [AuthRemoteDataSource] that handles actual API calls
/// using Dio HTTP client.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  /// Creates a new [AuthRemoteDataSourceImpl] instance with required dependencies.
  ///
  /// [dio] The Dio HTTP client instance for making API requests.
  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<NetworkException, AuthResponseModel>> createUser(AuthRequestModel request) async {
    try {
      final response = await _dio.post(
        NetworkConstants.authRegisterEndpoint,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(AuthResponseModel.fromJson(response.data));
      } else {
        return left(NetworkException(
          message: response.data['message'] ?? 'Failed to create user',
          statusCode: response.statusCode,
        ));
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? handleDioError(e);
      return left(NetworkException(
        message: message,
        statusCode: e.response?.statusCode,
      ));
    }
  }

  @override
  Future<Either<NetworkException, AuthResponseModel>> loginUser(AuthRequestModel request) async {
    try {
      final response = await _dio.post(
        NetworkConstants.authLoginEndpoint,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return right(AuthResponseModel.fromJson(response.data));
      } else {
        return left(NetworkException(
          message: response.data['message'] ?? 'Failed to login',
          statusCode: response.statusCode,
        ));
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? handleDioError(e);
      return left(NetworkException(
        message: message,
        statusCode: e.response?.statusCode,
      ));
    }
  }
}
