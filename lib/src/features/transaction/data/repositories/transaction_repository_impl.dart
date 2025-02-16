import 'package:dartz/dartz.dart';
import '../../../../core/network/exception/network_exception.dart';
import '../data_sources/remote/transaction_remote_data_source.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl({required TransactionRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<NetworkException, List<TransactionModel>>> getTransactions(String userId) async {
    try {
      final response = await _remoteDataSource.getTransactions(userId);
      return Right(response.transactions);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkException, String>> addTransaction(TransactionRequest request) async {
    try {
      final response = await _remoteDataSource.addTransaction(request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkException, String>> updateTransaction(
      String transactionId, TransactionUpdateRequest request) async {
    try {
      final response = await _remoteDataSource.updateTransaction(transactionId, request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkException, String>> deleteTransaction(DeleteTransactionRequest request) async {
    try {
      final response = await _remoteDataSource.deleteTransaction(request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }
}
