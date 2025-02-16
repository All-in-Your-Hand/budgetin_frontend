import 'package:flutter/material.dart';
import '../../domain/models/transaction_model.dart';

/// Provider that manages the state and behavior of the transaction table.
///
/// This provider handles:
/// - Sorting of transactions by different columns
/// - Filtering transactions by date range, recipient, amount, and type
/// - Maintaining the original and filtered transaction lists
class TransactionTableProvider extends ChangeNotifier {
  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> _filteredTransactions = [];

  /// The current list of filtered transactions to display.
  List<TransactionModel> get transactions => List.unmodifiable(_filteredTransactions);

  int? _sortColumnIndex;

  /// The index of the currently sorted column, if any.
  int? get sortColumnIndex => _sortColumnIndex;

  bool _sortAscending = true;

  /// Whether the current sort is in ascending order.
  bool get sortAscending => _sortAscending;

  // Filter states
  DateTime? _startDate;

  /// The start date of the current date filter, if any.
  DateTime? get startDate => _startDate;

  DateTime? _endDate;

  /// The end date of the current date filter, if any.
  DateTime? get endDate => _endDate;

  String _toFilter = '';

  /// The current recipient filter text.
  String get toFilter => _toFilter;

  double _minAmount = 0;

  /// The minimum amount filter value.
  double get minAmount => _minAmount;

  double _maxAmount = double.infinity;

  /// The maximum amount filter value.
  double get maxAmount => _maxAmount;

  String? _selectedType;

  /// The currently selected transaction type filter, if any.
  String? get selectedType => _selectedType;

  /// List of unique transaction types available in the dataset.
  List<String> get transactionTypes => List.unmodifiable(_allTransactions.map((t) => t.transactionType).toSet().toList()
    ..sort()); // TODO: Fetch transaction types from backend.

  Comparable<dynamic> Function(TransactionModel)? _currentSortField;

  /// Initializes the provider with a list of transactions.
  ///
  /// This method sets both the original and filtered transaction lists
  /// and updates the maximum amount based on the provided transactions.
  void initializeTransactions(List<TransactionModel> transactions) {
    _allTransactions = List.from(transactions);
    _filteredTransactions = List.from(transactions);
    _updateMaxAmount();

    // Set default sorting to date column (index 0) in descending order
    _sortColumnIndex = 0;
    _sortAscending = false;
    _currentSortField = (transaction) => transaction.transactionDate;
    _sortFilteredTransactions();

    notifyListeners();
  }

  /// Updates the maximum amount based on the current transaction list.
  void _updateMaxAmount() {
    if (_allTransactions.isNotEmpty) {
      _maxAmount = _allTransactions.map((t) => t.transactionAmount).reduce((a, b) => a > b ? a : b);
    }
  }

  /// Sets the date range filter.
  ///
  /// Both [start] and [end] can be null to clear the date filter.
  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _applyFilters();
  }

  /// Sets the recipient filter text.
  void setToFilter(String value) {
    _toFilter = value;
    _applyFilters();
  }

  /// Sets the amount range filter.
  ///
  /// The [min] value must be less than or equal to [max].
  void setAmountRange(double min, double max) {
    assert(min <= max, 'Minimum amount must be less than or equal to maximum amount');
    _minAmount = min;
    _maxAmount = max;
    _applyFilters();
  }

  /// Sets the transaction type filter.
  ///
  /// Pass null to clear the type filter.
  void setTransactionType(String? type) {
    _selectedType = type;
    _applyFilters();
  }

  /// Applies all current filters to the transaction list.
  void _applyFilters() {
    _filteredTransactions = _allTransactions.where((transaction) {
      // Date filter
      if (_startDate != null && transaction.transactionDate.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && transaction.transactionDate.isAfter(_endDate!)) {
        return false;
      }

      // To filter
      if (_toFilter.isNotEmpty && !transaction.to.toLowerCase().contains(_toFilter.toLowerCase())) {
        return false;
      }

      // Amount filter
      if (transaction.transactionAmount < _minAmount || transaction.transactionAmount > _maxAmount) {
        return false;
      }

      // Type filter
      if (_selectedType != null && transaction.transactionType != _selectedType) {
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

  /// Sorts the transaction list by the specified field.
  ///
  /// Parameters:
  ///   - getField: A function that extracts the comparable field from a transaction
  ///   - columnIndex: The index of the column being sorted
  void sort<T extends Comparable<T>>(T Function(TransactionModel transaction) getField, int columnIndex) {
    _currentSortField = getField;
    _sortAscending = _sortColumnIndex == columnIndex ? !_sortAscending : true;
    _sortColumnIndex = columnIndex;
    _sortFilteredTransactions();
    notifyListeners();
  }

  /// Applies the current sort to the filtered transactions list.
  void _sortFilteredTransactions() {
    if (_currentSortField == null) return;

    _filteredTransactions.sort((a, b) {
      final aValue = _currentSortField!(a);
      final bValue = _currentSortField!(b);

      // Special handling for string comparisons (like the "To" field)
      if (aValue is String && bValue is String) {
        return _sortAscending
            ? aValue.toLowerCase().compareTo(bValue.toLowerCase())
            : bValue.toLowerCase().compareTo(aValue.toLowerCase());
      }

      return _sortAscending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }

  /// Resets all filters to their default values.
  void resetFilters() {
    _startDate = null;
    _endDate = null;
    _toFilter = '';
    _minAmount = 0;
    _maxAmount = _allTransactions.isEmpty
        ? double.infinity
        : _allTransactions.map((t) => t.transactionAmount).reduce((a, b) => a > b ? a : b);
    _selectedType = null;
    _applyFilters();
  }
}
