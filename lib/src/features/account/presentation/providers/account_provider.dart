import 'package:flutter/material.dart';
import 'package:budgetin_frontend/src/core/utils/constant/network_constants.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:budgetin_frontend/src/features/account/domain/models/account_request.dart';
import 'package:budgetin_frontend/src/features/account/domain/repositories/account_repository.dart';

/// Provider for managing account-related state
class AccountProvider extends ChangeNotifier {
  final AccountRepository _repository;
  AccountModel? _account;
  String? _error;
  bool _isLoading = false;

  /// Creates a new [AccountProvider] instance
  AccountProvider(this._repository);

  /// Current account information
  AccountModel? get account => _account;

  /// Error message if any
  String? get error => _error;

  /// Whether account data is being loaded
  bool get isLoading => _isLoading;

  /// Get account information using hardcoded test IDs
  Future<void> getAccount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    const request = AccountRequest(
      accountId: NetworkConstants.testAccountId,
      userId: NetworkConstants.testUserId,
    );

    final result = await _repository.getAccount(request);

    result.fold(
      (failure) {
        _error = failure.message;
        _account = null;
      },
      (account) {
        _account = account;
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
