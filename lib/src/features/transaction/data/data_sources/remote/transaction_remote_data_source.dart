import 'package:dio/dio.dart';
import '../../../../../core/network/exception/network_exception.dart';
import '../../../../../core/utils/constant/network_constants.dart';
import '../../../domain/models/transaction_response.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';

abstract class TransactionRemoteDataSource {
  Future<String> addTransaction(TransactionRequest request);
  Future<TransactionResponse> getTransactions(String userId);
  Future<String> updateTransaction(
      String transactionId, TransactionUpdateRequest request);
}

/// Remote data source for transaction-related API calls
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio _dio;

  /// Creates a new [TransactionRemoteDataSource] instance
  TransactionRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  /// Get all transactions for a user from the API
  @override
  Future<TransactionResponse> getTransactions(String userId) async {
    try {
      final response = await _dio.get(
        NetworkConstants.getTransactionsByUserId(
            //TODO: change to REAL userId
            NetworkConstants.testUserId),
      );

      if (response.statusCode == 200) {
        return TransactionResponse.fromJson(response.data);
      } else {
        throw NetworkException(
          message: 'Failed to fetch transactions',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to fetch transactions',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> addTransaction(TransactionRequest request) async {
    try {
      final response = await _dio.post(
        NetworkConstants.transactionEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['message'] as String;
      } else {
        throw NetworkException(
          message: 'Failed to add transaction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to add transaction',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> updateTransaction(
      String transactionId, TransactionUpdateRequest request) async {
    try {
      final response = await _dio.put(
        NetworkConstants.transactionEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['message'] as String;
      } else {
        throw NetworkException(
          message: 'Failed to update transaction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? 'Failed to update transaction',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
