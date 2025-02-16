import 'package:budgetin_frontend/src/features/account/domain/models/account_response.dart';
import 'package:dio/dio.dart';
import 'package:budgetin_frontend/src/core/network/exception/network_exception.dart';
import 'package:budgetin_frontend/src/core/utils/constant/network_constants.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';

/// Remote data source interface for account-related API calls
abstract class AccountRemoteDataSource {
  /// Get all accounts for a user from the API
  Future<AccountResponse> getAccounts(AccountRequest request);

  /// Add a new account via the API
  Future<String> addAccount(AddAccountRequest request);

  /// Update an existing account via the API
  Future<String> updateAccount(AccountUpdateRequest request);

  /// Delete an account via the API
  Future<String> deleteAccount(DeleteAccountRequest request);
}

/// Implementation of [AccountRemoteDataSource]
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Dio _dio;

  /// Creates a new [AccountRemoteDataSource] instance
  AccountRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  /// Get all accounts for a user from the API
  @override
  Future<AccountResponse> getAccounts(AccountRequest request) async {
    try {
      final response = await _dio.get(
        NetworkConstants.getAccountsByUserId(
            //TODO: change to REAL userId
            NetworkConstants.testUserId),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        return AccountResponse.fromJson(response.data);
      } else {
        throw NetworkException(
          message: 'Failed to fetch accounts',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to fetch accounts',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> addAccount(AddAccountRequest request) async {
    try {
      final response = await _dio.post(
        NetworkConstants.accountEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return response.data['message'] as String;
      } else {
        throw NetworkException(
          message: 'Failed to add account',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to add account',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> updateAccount(AccountUpdateRequest request) async {
    try {
      final response = await _dio.put(
        NetworkConstants.accountEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['message'] as String;
      } else {
        throw NetworkException(
          message: 'Failed to update account',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to update account',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> deleteAccount(DeleteAccountRequest request) async {
    try {
      final response = await _dio.delete(
        NetworkConstants.accountEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['message'] as String;
      } else {
        throw NetworkException(
          message: 'Failed to delete account',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to delete account',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
