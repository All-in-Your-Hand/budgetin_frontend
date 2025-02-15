import 'package:dartz/dartz.dart';
import 'package:budgetin_frontend/src/core/network/exception/network_exception.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';

/// Repository interface for account-related operations
abstract class AccountRepository {
  /// Get all accounts for a user
  Future<Either<NetworkException, List<AccountModel>>> getAccounts(
      AccountRequest request);
}
