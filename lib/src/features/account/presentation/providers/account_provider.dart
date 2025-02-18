import 'package:flutter/material.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';
import 'package:budgetin_frontend/src/features/account/domain/repositories/account_repository.dart';

/// Provider for managing account-related state and operations.
/// Handles loading, creating, updating, and deleting accounts while managing loading states
/// and error handling.
class AccountProvider extends ChangeNotifier {
  final AccountRepository _repository;
  List<AccountModel> _accounts = [];
  String? _error;
  bool _isLoading = false;
  String? _lastDeletedAccountId;
  AccountModel? _lastDeletedAccount;

  /// Creates a new [AccountProvider] instance
  ///
  /// Requires an [AccountRepository] implementation for handling data operations
  AccountProvider({required AccountRepository repository}) : _repository = repository;

  /// Returns an unmodifiable list of the current accounts
  List<AccountModel> get accounts => List.unmodifiable(_accounts);

  /// Current error message, if any
  String? get error => _error;

  /// Whether any account operation is currently in progress
  bool get isLoading => _isLoading;

  /// Fetches all accounts for a specific user
  ///
  /// [userId] The ID of the user whose accounts should be fetched
  /// Throws [NetworkException] if the network request fails
  Future<void> getAccounts(String userId) async {
    _setLoading(true);
    _clearError();

    final request = GetAccountRequest(userId: userId);
    final result = await _repository.getAccounts(request);

    result.fold(
      (failure) {
        _error = failure.message;
        _accounts = [];
      },
      (accounts) {
        _accounts = accounts;
        _clearError();
      },
    );

    _setLoading(false);
  }

  /// Adds a new account to the system
  ///
  /// [request] The account creation request containing the new account details
  /// Returns true if the operation was successful, false otherwise
  Future<bool> addAccount(AddAccountRequest request) async {
    _setLoading(true);
    _clearError();

    // Optimistically add the account
    final tempAccount = AccountModel(
      id: DateTime.now().toIso8601String(), // Temporary ID
      userId: request.userId,
      accountName: request.accountName,
      balance: request.balance,
    );
    _accounts = [..._accounts, tempAccount];
    notifyListeners();

    final result = await _repository.addAccount(request);

    result.fold(
      (failure) {
        _error = failure.message;
        // Revert optimistic update
        _accounts.removeLast();
        notifyListeners();
      },
      (success) {
        _clearError();
        // Refresh the accounts list to get the server-generated ID
        getAccounts(request.userId);
      },
    );

    _setLoading(false);
    return result.isRight();
  }

  /// Updates an existing account
  ///
  /// [request] The account update request containing the modified account details
  /// Returns true if the operation was successful, false otherwise
  Future<bool> updateAccount(UpdateAccountRequest request) async {
    _setLoading(true);
    _clearError();

    // Store the original account state
    final accountIndex = _accounts.indexWhere((a) => a.id == request.account.id);
    final originalAccount = _accounts[accountIndex];

    // Optimistically update the account
    _accounts = List.from(_accounts)..[accountIndex] = request.account;
    notifyListeners();

    final result = await _repository.updateAccount(request);

    result.fold(
      (failure) {
        _error = failure.message;
        // Revert optimistic update
        _accounts = List.from(_accounts)..[accountIndex] = originalAccount;
      },
      (success) => _clearError(),
    );

    _setLoading(false);
    notifyListeners();
    return result.isRight();
  }

  /// Deletes an account from the system
  ///
  /// [accountId] The ID of the account to delete
  /// Returns true if the operation was successful, false otherwise
  Future<bool> deleteAccount(String accountId) async {
    _setLoading(true);
    _clearError();

    // Store the account for potential undo
    final accountIndex = _accounts.indexWhere((a) => a.id == accountId);
    _lastDeletedAccount = _accounts[accountIndex];
    _lastDeletedAccountId = accountId;

    // Optimistically remove the account
    _accounts = List.from(_accounts)..removeAt(accountIndex);
    notifyListeners();

    final request = DeleteAccountRequest(accountId: accountId);
    final result = await _repository.deleteAccount(request);

    result.fold(
      (failure) {
        _error = failure.message;
        // Revert optimistic delete
        if (_lastDeletedAccount != null) {
          _accounts = List.from(_accounts)..insert(accountIndex, _lastDeletedAccount!);
        }
      },
      (success) {
        _clearError();
        _lastDeletedAccount = null;
        _lastDeletedAccountId = null;
      },
    );

    _setLoading(false);
    notifyListeners();
    return result.isRight();
  }

  /// Attempts to undo the last account deletion
  ///
  /// Returns true if the undo was successful, false if there's nothing to undo
  /// or if the operation failed
  Future<bool> undoDelete() async {
    if (_lastDeletedAccount == null || _lastDeletedAccountId == null) {
      return false;
    }

    final accountToRestore = _lastDeletedAccount!;
    final request = AddAccountRequest(
      userId: accountToRestore.userId,
      accountName: accountToRestore.accountName,
      balance: accountToRestore.balance,
    );

    return addAccount(request);
  }

  /// Sets the loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clears any existing error state
  void _clearError() {
    _error = null;
  }
}
