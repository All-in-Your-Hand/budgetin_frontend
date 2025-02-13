import 'package:dio/dio.dart';
import '../../../../../core/network/error/network_exception.dart';
import '../../../../../core/utils/constant/network_constants.dart';
import '../../models/transaction_response.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionResponse> getTransactions(String userId);
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
}
