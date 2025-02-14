// import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../domain/models/auth_request_model.dart';
import '../../../domain/models/auth_response_model.dart';
import '../../../../../core/utils/constant/network_constants.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> createUser(AuthRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> createUser(AuthRequestModel request) async {
    try {
      final response = await dio.post(
        NetworkConstants.userEndpoint,
        data: request.toJson(),
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error creating user: ${e.message}');
      throw Exception('Failed to create user: ${e.message}');
    }
  }
}
