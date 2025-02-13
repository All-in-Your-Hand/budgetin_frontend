import 'package:dartz/dartz.dart';
import '../../../../core/network/error/network_exception.dart';
import '../data_sources/remote/transaction_remote_data_source.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, List<TransactionModel>>> getTransactions(
      String userId) async {
    try {
      final response = await remoteDataSource.getTransactions(userId);
      return Right(response.transactions);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }
}
