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
        NetworkConstants.getAccountByIdAndUserId(),
      );

      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to fetch account',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
