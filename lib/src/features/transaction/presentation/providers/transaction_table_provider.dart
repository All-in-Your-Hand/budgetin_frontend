import 'package:flutter/material.dart';
import '../../domain/models/transaction_model.dart';

class TransactionTableProvider extends ChangeNotifier {
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];
  List<Transaction> get transactions => _filteredTransactions;

  int? _sortColumnIndex;
  int? get sortColumnIndex => _sortColumnIndex;

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;

  // Filter states
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  String _toFilter = '';
  String get toFilter => _toFilter;

  double _minAmount = 0;
  double get minAmount => _minAmount;
  double _maxAmount = double.infinity;
  double get maxAmount => _maxAmount;

  String? _selectedType;
  String? get selectedType => _selectedType;
  List<String> get transactionTypes =>
      _allTransactions.map((t) => t.transactionType).toSet().toList()..sort();

  void initializeTransactions(List<Transaction> transactions) {
    _allTransactions = List.from(transactions);
    _filteredTransactions = List.from(transactions);
    _updateMaxAmount();
    notifyListeners();
  }

  void _updateMaxAmount() {
    if (_allTransactions.isNotEmpty) {
      _maxAmount = _allTransactions
          .map((t) => t.transactionAmount)
          .reduce((a, b) => a > b ? a : b);
    }
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _applyFilters();
  }

  void setToFilter(String value) {
    _toFilter = value;
    _applyFilters();
  }

  void setAmountRange(double min, double max) {
    _minAmount = min;
    _maxAmount = max;
    _applyFilters();
  }

  void setTransactionType(String? type) {
    _selectedType = type;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTransactions = _allTransactions.where((transaction) {
      // Date filter
      if (_startDate != null &&
          transaction.transactionDate.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && transaction.transactionDate.isAfter(_endDate!)) {
        return false;
      }

      // To filter
      if (_toFilter.isNotEmpty &&
          !transaction.to.toLowerCase().contains(_toFilter.toLowerCase())) {
        return false;
      }

      // Amount filter
      if (transaction.transactionAmount < _minAmount ||
          transaction.transactionAmount > _maxAmount) {
        return false;
      }

      // Type filter
      if (_selectedType != null &&
          transaction.transactionType != _selectedType) {
        return false;
      }

      return true;
    }).toList();

    // Maintain sort if applied
    if (_sortColumnIndex != null && _currentSortField != null) {
      _sortFilteredTransactions();
    }

    notifyListeners();
  }

  Comparable<dynamic> Function(Transaction)? _currentSortField;

  void sort<T>(Comparable<T> Function(Transaction transaction) getField,
      int columnIndex) {
    _currentSortField = getField;
    _sortAscending = _sortColumnIndex == columnIndex ? !_sortAscending : true;
    _sortColumnIndex = columnIndex;
    _sortFilteredTransactions();
    notifyListeners();
  }

  void _sortFilteredTransactions() {
    if (_currentSortField == null) return;

    _filteredTransactions.sort((a, b) {
      final aValue = _currentSortField!(a);
      final bValue = _currentSortField!(b);
      return _sortAscending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
  }

  void resetFilters() {
    _startDate = null;
    _endDate = null;
    _toFilter = '';
    _minAmount = 0;
    _maxAmount = _allTransactions.isEmpty
        ? double.infinity
        : _allTransactions
            .map((t) => t.transactionAmount)
            .reduce((a, b) => a > b ? a : b);
    _selectedType = null;
    _applyFilters();
  }
}
