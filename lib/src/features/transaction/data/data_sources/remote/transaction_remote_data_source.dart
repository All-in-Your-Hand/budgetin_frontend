import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/exceptions/network_exception.dart';
import '../../../../../core/utils/constant/network_constants.dart';
import '../../../domain/models/transaction_response.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';
import 'package:budgetin_frontend/src/core/network/error/dio_error_handler.dart';
import 'package:budgetin_frontend/src/core/storage/storage_service.dart';

/// Remote data source interface for transaction-related API operations.
/// Handles all network requests related to transaction management including
/// fetching, creating, updating and deleting transactions.
abstract class TransactionRemoteDataSource {
  /// Creates a new transaction with the provided details.
  ///
  /// Returns [Either] with success message on success or [NetworkException] on failure.
  /// [request] contains the new transaction details.
  Future<Either<NetworkException, String>> addTransaction(AddTransactionRequest request);

  /// Retrieves all transactions associated with the specified user.
  ///
  /// Returns [Either] with [TransactionResponse] on success or [NetworkException] on failure.
  /// [request] contains the parameters for fetching transactions.
  Future<Either<NetworkException, TransactionResponse>> getTransactions(GetTransactionRequest request);

  /// Updates an existing transaction with new information.
  ///
  /// Returns [Either] with success message on success or [NetworkException] on failure.
  /// [request] contains the transaction update information including the transaction ID.
  Future<Either<NetworkException, String>> updateTransaction(UpdateTransactionRequest request);

  /// Deletes an existing transaction.
  ///
  /// Returns [Either] with success message on success or [NetworkException] on failure.
  /// [request] contains the transaction identifier to be deleted.
  Future<Either<NetworkException, String>> deleteTransaction(DeleteTransactionRequest request);
}

/// Implementation of [TransactionRemoteDataSource] that handles actual API calls
/// using Dio HTTP client.
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio _dio;
  final StorageService _storage;

  /// Creates a new [TransactionRemoteDataSourceImpl] instance with required dependencies.
  ///
  /// [dio] The Dio HTTP client instance for making API requests.
  /// [storage] The storage service for accessing the JWT token.
  TransactionRemoteDataSourceImpl({
    required Dio dio,
    required StorageService storage,
  })  : _dio = dio,
        _storage = storage;

  /// Gets the authorization header with the JWT token.
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'access_token');
    return {
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<Either<NetworkException, String>> addTransaction(AddTransactionRequest request) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.post(
        NetworkConstants.transactionEndpoint,
        data: request.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return Right(response.data['message'] as String);
      } else {
        return Left(NetworkException(
          message: 'Failed to add transaction',
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
  Future<Either<NetworkException, TransactionResponse>> getTransactions(GetTransactionRequest request) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.get(
        NetworkConstants.getTransactionsByUserId(request.userId),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        return Right(TransactionResponse.fromJson(response.data));
      } else {
        return Left(NetworkException(
          message: 'Failed to fetch transactions',
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
  Future<Either<NetworkException, String>> updateTransaction(UpdateTransactionRequest request) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.put(
        NetworkConstants.transactionEndpoint,
        data: request.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return Right(response.data['message'] as String);
      } else {
        return Left(NetworkException(
          message: 'Failed to update transaction',
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
  Future<Either<NetworkException, String>> deleteTransaction(DeleteTransactionRequest request) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.delete(
        NetworkConstants.transactionEndpoint,
        data: request.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return Right(response.data['message'] as String);
      } else {
        return Left(NetworkException(
          message: 'Failed to delete transaction',
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
