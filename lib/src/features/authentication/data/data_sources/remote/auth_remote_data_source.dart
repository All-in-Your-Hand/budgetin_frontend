// import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../domain/models/auth_request_model.dart';
import '../../../domain/models/auth_response_model.dart';
import '../../../../../core/utils/constant/network_constants.dart';
import '../../../../../core/network/exception/network_exception.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> createUser(AuthRequestModel request);
}

/// Remote data source for authentication-related API calls
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  /// Creates a new [AuthRemoteDataSource] instance
  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<AuthResponseModel> createUser(AuthRequestModel request) async {
    try {
      final response = await _dio.post(
        //TODO: use real endpoint
        NetworkConstants.userEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw NetworkException(
          message: 'Failed to create user',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to create user',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
