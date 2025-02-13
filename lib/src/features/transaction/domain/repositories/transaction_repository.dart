import 'package:dartz/dartz.dart';
import '../../../../core/network/error/network_exception.dart';
import '../models/transaction_model.dart';

/// Repository interface for handling transaction-related operations
///
/// Provides methods to interact with transaction data sources and handles
/// the business logic for transaction operations.
abstract class TransactionRepository {
  /// Retrieves a list of transactions for a given user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns a [Future] that resolves to an [Either] containing either:
  ///   - Left: [NetworkException] if the operation fails
  ///   - Right: List of [TransactionModel] if successful
  Future<Either<NetworkException, List<TransactionModel>>> getTransactions(
      String userId);
}
