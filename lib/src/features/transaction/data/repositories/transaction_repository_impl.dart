import 'package:dartz/dartz.dart';
import 'package:budgetin_frontend/src/core/exceptions/network_exception.dart';
import 'package:budgetin_frontend/src/features/transaction/data/data_sources/remote/transaction_remote_data_source.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_model.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/repositories/transaction_repository.dart';

/// Implementation of [TransactionRepository] that handles the coordination between
/// remote data sources and implements the business logic for transaction operations.
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  /// Creates a new [TransactionRepositoryImpl] instance.
  ///
  /// Requires a [TransactionRemoteDataSource] for handling network operations.
  TransactionRepositoryImpl({required TransactionRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<NetworkException, String>> addTransaction(AddTransactionRequest request) async {
    final response = await _remoteDataSource.addTransaction(request);

    return response.fold(
      (failure) => Left(failure),
      (successMessage) => Right(successMessage),
    );
  }

  @override
  Future<Either<NetworkException, List<TransactionModel>>> getTransactions(GetTransactionRequest request) async {
    final response = await _remoteDataSource.getTransactions(request);

    return response.fold(
      (failure) => Left(failure),
      (transactionResponse) => Right(transactionResponse.transactions),
    );
  }

  @override
  Future<Either<NetworkException, String>> updateTransaction(UpdateTransactionRequest request) async {
    final response = await _remoteDataSource.updateTransaction(request);

    return response.fold(
      (failure) => Left(failure),
      (successMessage) => Right(successMessage),
    );
  }

  @override
  Future<Either<NetworkException, String>> deleteTransaction(DeleteTransactionRequest request) async {
    final response = await _remoteDataSource.deleteTransaction(request);

    return response.fold(
      (failure) => Left(failure),
      (successMessage) => Right(successMessage),
    );
  }
}
