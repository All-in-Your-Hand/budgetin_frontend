import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../models/transaction_model.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';

/// Repository interface for handling transaction-related operations
///
/// Provides methods to interact with transaction data sources and handles
/// the business logic for transaction operations.
abstract class TransactionRepository {
  /// Adds a new transaction to the database
  ///
  /// Parameters:
  ///   - request: The transaction request to add
  ///
  /// Returns a [Future] that resolves to an [Either] containing either:
  ///   - Left: [NetworkException] if the operation fails
  ///   - Right: String message if successful
  Future<Either<NetworkException, String>> addTransaction(AddTransactionRequest request);

  /// Retrieves a list of transactions for a given user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns a [Future] that resolves to an [Either] containing either:
  ///   - Left: [NetworkException] if the operation fails
  ///   - Right: List of [TransactionModel] if successful
  Future<Either<NetworkException, List<TransactionModel>>> getTransactions(GetTransactionRequest request);

  /// Updates an existing transaction in the database
  ///
  /// Parameters:
  ///   - transactionId: The unique identifier of the transaction to update
  ///   - request: The transaction update request
  ///
  /// Returns a [Future] that resolves to an [Either] containing either:
  ///   - Left: [NetworkException] if the operation fails
  ///   - Right: String message if successful
  Future<Either<NetworkException, String>> updateTransaction(UpdateTransactionRequest request);

  /// Deletes a transaction from the database
  ///
  /// Parameters:
  ///   - request: The delete transaction request containing transactionId and userId
  ///
  /// Returns a [Future] that resolves to an [Either] containing either:
  ///   - Left: [NetworkException] if the operation fails
  ///   - Right: String message if successful
  Future<Either<NetworkException, String>> deleteTransaction(DeleteTransactionRequest request);
}
