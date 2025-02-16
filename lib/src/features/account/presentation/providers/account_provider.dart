import 'package:flutter/material.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';
import 'package:budgetin_frontend/src/features/account/domain/repositories/account_repository.dart';

/// Provider for managing account-related state
class AccountProvider extends ChangeNotifier {
  final AccountRepository _repository;
  List<AccountModel> _accounts = [];
  String? _error;
  bool _isLoading = false;

  /// Creates a new [AccountProvider] instance
  AccountProvider({required AccountRepository repository}) : _repository = repository;

  /// Current list of accounts
  List<AccountModel> get accounts => List.unmodifiable(_accounts);

  /// Error message if any
  String? get error => _error;

  /// Whether account data is being loaded
  bool get isLoading => _isLoading;

  /// Get accounts for a specific user
  Future<void> getAccounts(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final request = AccountRequest(
      userId: userId,
    );

    final result = await _repository.getAccounts(request);

    result.fold(
      (failure) {
        _error = failure.message;
        _accounts = [];
      },
      (accounts) {
        _accounts = accounts;
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Add a new account
  Future<bool> addAccount(AddAccountRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.addAccount(request);

    result.fold(
      (failure) {
        _error = failure.message;
      },
      (success) {
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
    return result.isRight();
  }

  /// Update an existing account
  Future<bool> updateAccount(AccountUpdateRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.updateAccount(request);

    result.fold(
      (failure) {
        _error = failure.message;
      },
      (success) {
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
    return result.isRight();
  }

  /// Delete an account
  Future<bool> deleteAccount(String accountId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final request = DeleteAccountRequest(accountId: accountId);

    final result = await _repository.deleteAccount(request);

    result.fold(
      (failure) {
        _error = failure.message;
      },
      (success) {
        _error = null;
        _accounts.removeWhere((account) => account.id == accountId);
      },
    );

    _isLoading = false;
    notifyListeners();
    return result.isRight();
  }
}
