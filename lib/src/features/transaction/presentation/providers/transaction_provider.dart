import 'package:flutter/foundation.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';

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
  TransactionProvider({required TransactionRepository repository}) : _repository = repository;

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

  /// Validates the date field.
  ///
  /// Returns an error message if the date is invalid or empty,
  /// otherwise returns null.
  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  /// Validates the category field.
  ///
  /// Returns an error message if the category is not selected,
  /// otherwise returns null.
  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  /// Validates the account field.
  ///
  /// Returns an error message if the account is not selected,
  /// otherwise returns null.
  String? validateAccount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an account';
    }
    return null;
  }

  /// Validates the amount field.
  ///
  /// Returns an error message if the amount is invalid,
  /// otherwise returns null.
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Invalid amount';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  /// Validates the transaction type field.
  ///
  /// Returns an error message if the type is not selected,
  /// otherwise returns null.
  String? validateTransactionType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a transaction type';
    }
    return null;
  }

  /// Adds a new transaction to the repository.
  ///
  /// Parameters:
  ///   - request: The [AddTransactionRequest] containing transaction details
  ///
  /// Returns a Future that completes with true if the transaction was added successfully,
  /// false otherwise.
  Future<bool> addTransaction(AddTransactionRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.addTransaction(request);

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (success) {
        _error = null;
        _isLoading = false;
      },
    );

    notifyListeners();
    return result.isRight();
  }

  /// Fetches transactions for the specified user.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user whose transactions to fetch
  ///
  /// Updates the provider state and notifies listeners of any changes.
  /// Sets [isLoading] while the operation is in progress and updates
  /// either [transactions] or [error] based on the result.
  Future<void> getTransactions(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getTransactions(GetTransactionRequest(userId: userId));

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

  /// Updates a transaction in the repository.
  ///
  /// Parameters:
  ///   - transactionId: The unique identifier of the transaction to update
  ///   - request: The updated transaction request
  ///
  /// Returns a Future that completes with true if the update was successful,
  /// false otherwise.
  Future<bool> updateTransaction(UpdateTransactionRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.updateTransaction(request);

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (success) {
        _error = null;
        _isLoading = false;
      },
    );

    notifyListeners();
    return result.isRight();
  }

  /// Deletes a transaction from the repository.
  ///
  /// Parameters:
  ///   - transactionId: The unique identifier of the transaction to delete
  ///   - userId: The unique identifier of the user who owns the transaction
  ///
  /// Returns a Future that completes with true if the deletion was successful,
  /// false otherwise.
  Future<bool> deleteTransaction(String transactionId, String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final request = DeleteTransactionRequest(
      transactionId: transactionId,
      userId: userId,
    );

    final result = await _repository.deleteTransaction(request);

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (success) {
        _error = null;
        _isLoading = false;
        // Remove the deleted transaction from the local list
        _transactions.removeWhere((t) => t.transactionId == transactionId);
      },
    );

    notifyListeners();
    return result.isRight();
  }
}
