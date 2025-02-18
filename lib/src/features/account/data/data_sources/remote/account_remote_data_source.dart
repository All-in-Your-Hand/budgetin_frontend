import 'package:budgetin_frontend/src/core/network/error/dio_error_handler.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_response.dart';
import 'package:dio/dio.dart';
import 'package:budgetin_frontend/src/core/exceptions/network_exception.dart';
import 'package:budgetin_frontend/src/core/utils/constant/network_constants.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';
import 'package:dartz/dartz.dart';

/// Remote data source interface for account-related API operations.
/// Handles all network requests related to account management including
/// fetching, creating, updating and deleting accounts.
abstract class AccountRemoteDataSource {
  /// Retrieves all accounts associated with the current user.
  ///
  /// Returns [Either] with [AccountResponse] on success or [NetworkException] on failure.
  /// [request] contains the parameters needed for the API call.
  Future<Either<NetworkException, AccountResponse>> getAccounts(GetAccountRequest request);

  /// Creates a new account with the provided details.
  ///
  /// Returns [Either] with success message on success or [NetworkException] on failure.
  /// [request] contains the new account details.
  Future<Either<NetworkException, String>> addAccount(AddAccountRequest request);

  /// Updates an existing account with new information.
  ///
  /// Returns [Either] with success message on success or [NetworkException] on failure.
  /// [request] contains the updated account information.
  Future<Either<NetworkException, String>> updateAccount(UpdateAccountRequest request);

  /// Deletes an existing account.
  ///
  /// Returns [Either] with success message on success or [NetworkException] on failure.
  /// [request] contains the account identifier to be deleted.
  Future<Either<NetworkException, String>> deleteAccount(DeleteAccountRequest request);
}

/// Implementation of [AccountRemoteDataSource] that handles actual API calls
/// using Dio HTTP client.
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Dio _dio;

  /// Creates a new [AccountRemoteDataSourceImpl] instance with required dependencies.
  ///
  /// [dio] The Dio HTTP client instance for making API requests.
  AccountRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<NetworkException, AccountResponse>> getAccounts(GetAccountRequest request) async {
    try {
      final response = await _dio.get(
        NetworkConstants.getAccountsByUserId(request.userId),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        return Right(AccountResponse.fromJson(response.data));
      } else {
        return Left(NetworkException(
          message: 'Failed to fetch accounts',
          statusCode: response.statusCode,
        ));
      }
    } on DioException catch (e) {
      return Left(NetworkException(
        message: handleDioError(e),
        statusCode: e.response?.statusCode,
      ));
    }
  }

  @override
  Future<Either<NetworkException, String>> addAccount(AddAccountRequest request) async {
    try {
      final response = await _dio.post(
        NetworkConstants.accountEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return Right(response.data['message'] as String);
      } else {
        return Left(NetworkException(
          message: 'Failed to add account',
          statusCode: response.statusCode,
        ));
      }
    } on DioException catch (e) {
      return Left(NetworkException(
        message: handleDioError(e),
        statusCode: e.response?.statusCode,
      ));
    }
  }

  @override
  Future<Either<NetworkException, String>> updateAccount(UpdateAccountRequest request) async {
    try {
      final response = await _dio.put(
        NetworkConstants.accountEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(response.data['message'] as String);
      } else {
        return Left(NetworkException(
          message: 'Failed to update account',
          statusCode: response.statusCode,
        ));
      }
    } on DioException catch (e) {
      return Left(NetworkException(
        message: handleDioError(e),
        statusCode: e.response?.statusCode,
      ));
    }
  }

  @override
  Future<Either<NetworkException, String>> deleteAccount(DeleteAccountRequest request) async {
    try {
      final response = await _dio.delete(
        NetworkConstants.accountEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(response.data['message'] as String);
      } else {
        return Left(NetworkException(
          message: 'Failed to delete account',
          statusCode: response.statusCode,
        ));
      }
    } on DioException catch (e) {
      return Left(NetworkException(
        message: handleDioError(e),
        statusCode: e.response?.statusCode,
      ));
    }
  }
}
