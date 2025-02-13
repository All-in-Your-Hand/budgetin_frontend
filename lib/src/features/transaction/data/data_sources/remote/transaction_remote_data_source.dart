import 'package:dio/dio.dart';
import '../../../../../core/network/error/network_exception.dart';
import '../../../../../core/utils/constant/network_constants.dart';
import '../../../domain/models/transaction_response.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionResponse> getTransactions(String userId);
  Future<String> addTransaction(TransactionRequest request);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({required this.dio});

  @override
  Future<TransactionResponse> getTransactions(String userId) async {
    try {
      final response = await dio.get(
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
      print('Sending transaction request: ${request.toJson()}'); // Debug log
      final response = await dio.post(
        NetworkConstants.transactionEndpoint,
        data: request.toJson(),
      );
      print('Server response: ${response.data}'); // Debug log

      return response.data['message'] as String;
    } catch (e) {
      print('Error in addTransaction: $e'); // Debug log
      rethrow;
    }
  }
}
