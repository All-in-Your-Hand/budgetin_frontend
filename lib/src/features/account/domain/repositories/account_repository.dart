import 'package:dartz/dartz.dart';
import 'package:budgetin_frontend/src/core/exceptions/network_exception.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';

/// Repository interface for account-related operations.
/// This interface defines the contract for managing account data,
/// following clean architecture principles to separate domain logic from data implementation.
abstract class AccountRepository {
  /// Retrieves all accounts for the specified user.
  ///
  /// Returns [Either] with a list of [AccountModel] on success or [NetworkException] on failure.
  /// [request] contains the user identifier and any filtering parameters.
  Future<Either<NetworkException, List<AccountModel>>> getAccounts(GetAccountRequest request);

  /// Creates a new account in the system.
  ///
  /// Returns [Either] with a success message on success or [NetworkException] on failure.
  /// [request] contains the account details to be created.
  Future<Either<NetworkException, String>> addAccount(AddAccountRequest request);

  /// Updates an existing account with new information.
  ///
  /// Returns [Either] with a success message on success or [NetworkException] on failure.
  /// [request] contains the account identifier and updated information.
  Future<Either<NetworkException, String>> updateAccount(UpdateAccountRequest request);

  /// Removes an account from the system.
  ///
  /// Returns [Either] with a success message on success or [NetworkException] on failure.
  /// [request] contains the account identifier to be deleted.
  Future<Either<NetworkException, String>> deleteAccount(DeleteAccountRequest request);
}
