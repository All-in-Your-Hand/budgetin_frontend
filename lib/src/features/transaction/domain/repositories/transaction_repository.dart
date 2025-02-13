import 'package:dartz/dartz.dart';
import '../../../../core/network/error/network_exception.dart';
import '../models/transaction_model.dart';

abstract class TransactionRepository {
  Future<Either<NetworkException, List<TransactionModel>>> getTransactions(
      String userId);
}
