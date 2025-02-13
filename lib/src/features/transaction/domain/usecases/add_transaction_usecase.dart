import 'package:dartz/dartz.dart';
import 'package:budgetin_frontend/src/core/network/error/failures.dart';
import 'package:budgetin_frontend/src/core/utils/usecases/usecase.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/repositories/transaction_repository.dart';

class AddTransactionUseCase implements UseCase<String, TransactionRequest> {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(TransactionRequest params) async {
    return await repository.addTransaction(params);
  }
}
