import 'package:flutter/material.dart';
import '../../domain/models/transaction_model.dart';

class TransactionTableProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  int? _sortColumnIndex;
  int? get sortColumnIndex => _sortColumnIndex;

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;

  void initializeTransactions(List<Transaction> transactions) {
    _transactions = List.from(transactions);
    notifyListeners();
  }

  void sort<T>(Comparable<T> Function(Transaction transaction) getField,
      int columnIndex) {
    final ascending = _sortColumnIndex == columnIndex ? !_sortAscending : true;

    _transactions.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    _sortColumnIndex = columnIndex;
    _sortAscending = ascending;
    notifyListeners();
  }
}
