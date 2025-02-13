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
  ///   - date: The transaction date in dd/MM/yyyy format
  ///   - to: The recipient of the transaction (optional)
  ///   - category: The transaction category
  ///   - account: The account from which the transaction was made
  ///   - amount: The transaction amount as a string
  ///   - type: The type of transaction (expense/income)
  ///   - notes: Additional notes about the transaction (optional)
  ///
  /// Returns a Future that completes when the transaction is added.
  Future<void> addTransaction({
    required String date,
    String? to,
    required String category,
    required String account,
    required String amount,
    required String type,
    String? notes,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement the actual transaction addition logic with the repository
      // This is a placeholder that just adds to the local list for now
      final newTransaction = TransactionModel(
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user', // TODO: Get from auth
        accountId: account,
        transactionType: type,
        transactionCategory: category,
        transactionAmount: double.parse(amount),
        createdAt: DateTime.now(),
        transactionDate: DateTime.parse(date.split('/').reversed.join('-')),
        description: notes ?? '',
        to: to ?? '',
      );

      // TODO: Replace with proper logging
      print('Adding new transaction: ${newTransaction.transactionId}');
      print('Date: $date');
      print('To: $to');
      print('Category: $category');
      print('Account: $account');
      print('Amount: $amount');
      print('Type: $type');
      print('Notes: $notes');

      _transactions.add(newTransaction);
      _error = null;
    } catch (e) {
      _error = 'Failed to add transaction: ${e.toString()}';
      // TODO: Replace with proper logging
      print('Error adding transaction: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
