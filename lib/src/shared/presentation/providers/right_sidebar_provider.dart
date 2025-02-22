import 'package:flutter/material.dart';
import '../../../features/transaction/domain/models/transaction_model.dart';

/// Provider class for managing the right sidebar state.
class RightSidebarProvider extends ChangeNotifier {
  bool _isExpanded = true;
  TransactionModel? _transactionToEdit;
  bool get isEditing => _transactionToEdit != null;

  /// The transaction being edited, if any.
  TransactionModel? get transactionToEdit => _transactionToEdit;

  /// Whether the right sidebar is expanded.
  bool get isExpanded => _isExpanded;

  /// Starts editing a transaction in the sidebar
  void startEditing(TransactionModel transaction) {
    _transactionToEdit = transaction;
    expand();
    notifyListeners();
  }

  /// Cancels editing and clears the transaction
  void cancelEditing() {
    _transactionToEdit = null;
    notifyListeners();
  }

  /// Toggles the expanded state of the right sidebar.
  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  /// Expands the right sidebar.
  void expand() {
    if (!_isExpanded) {
      _isExpanded = true;
      notifyListeners();
    }
  }

  /// Collapses the right sidebar.
  void collapse() {
    if (_isExpanded) {
      _isExpanded = false;
      _transactionToEdit = null;
      notifyListeners();
    }
  }

  /// Initializes the sidebar for the screen size.
  void initializeForScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 650) {
      _isExpanded = true;
      notifyListeners();
    }
  }
}
