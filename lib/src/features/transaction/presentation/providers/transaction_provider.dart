import 'package:flutter/foundation.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';

/// Provider class that manages the state of transactions in the application.
///
/// This provider handles loading, storing, and managing transaction data,
/// including error states and loading states. It communicates with the
/// [TransactionRepository] to fetch transaction data.
class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  /// Creates a new instance of [TransactionProvider].
  ///
  /// Requires a [TransactionRepository] instance to handle data operations.
  TransactionProvider({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// The current list of transactions.
  ///
  /// Returns an unmodifiable list of [TransactionModel] objects.
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  /// Whether the provider is currently loading data.
  bool get isLoading => _isLoading;

  /// The current error message, if any.
  ///
  /// Returns null if there is no error.
  String? get error => _error;

  /// Fetches transactions for the specified user.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user whose transactions to fetch
  ///
  /// Updates the provider state and notifies listeners of any changes.
  /// Sets [isLoading] while the operation is in progress and updates
  /// either [transactions] or [error] based on the result.
  Future<void> fetchTransactions(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getTransactions(userId);

    result.fold(
      (failure) {
        _error = failure.message;
        _transactions = [];
      },
      (transactions) {
        _transactions = transactions;
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
