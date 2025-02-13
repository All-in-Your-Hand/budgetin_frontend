import 'package:flutter/foundation.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  TransactionProvider({
    required TransactionRepository repository,
  }) : _repository = repository;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
