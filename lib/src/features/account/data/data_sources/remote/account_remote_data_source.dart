import 'package:dio/dio.dart';
import 'package:budgetin_frontend/src/core/network/error/network_exception.dart';
import 'package:budgetin_frontend/src/core/utils/constant/network_constants.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';

/// Remote data source for account-related API calls
class AccountRemoteDataSource {
  final Dio _dio;

  /// Creates a new [AccountRemoteDataSource] instance
  AccountRemoteDataSource(this._dio);

  /// Get account information from the API
  Future<AccountModel> getAccount(AccountRequest request) async {
    try {
      final response = await _dio.get(
        NetworkConstants.getAccountsByUserId(request.userId),
      );

      final Map<String, dynamic> data = response.data;
      if (data['accounts'] == null || (data['accounts'] as List).isEmpty) {
        throw NetworkException(
          message: 'No accounts found',
          statusCode: 404,
        );
      }

      return AccountModel.fromJson(data['accounts'][0]);
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to fetch account',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get all accounts for a user from the API
  Future<List<AccountModel>> getAccounts(AccountRequest request) async {
    try {
      final response = await _dio.get(
        NetworkConstants.getAccountsByUserId(request.userId),
      );

      final Map<String, dynamic> data = response.data;
      if (data['accounts'] == null) {
        throw NetworkException(
          message: 'Invalid response format: missing accounts field',
          statusCode: 500,
        );
      }

      final List<dynamic> accountsJson = data['accounts'];
      return accountsJson.map((json) => AccountModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to fetch accounts',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
