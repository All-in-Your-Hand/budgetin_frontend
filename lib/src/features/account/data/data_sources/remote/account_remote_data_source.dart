import 'package:budgetin_frontend/src/features/account/domain/models/account_response.dart';
import 'package:dio/dio.dart';
import 'package:budgetin_frontend/src/core/network/exception/network_exception.dart';
import 'package:budgetin_frontend/src/core/utils/constant/network_constants.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';

abstract class AccountRemoteDataSource {
  Future<AccountResponse> getAccounts(AccountRequest request);
}

/// Remote data source for account-related API calls
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

      if (response.statusCode == 200) {
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
}
