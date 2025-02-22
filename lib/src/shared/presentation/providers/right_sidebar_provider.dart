import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/transaction/domain/models/transaction_model.dart';
import 'sidebar_provider.dart';

/// Provider class for managing the right sidebar state.
class RightSidebarProvider extends ChangeNotifier {
  bool _isExpanded = true;
  TransactionModel? _transactionToEdit;
  bool get isEditing => _transactionToEdit != null;

  /// The width of the sidebar when expanded
  static const double expandedWidth = 344.0; // 320 + 24 for toggle button

  /// The transaction being edited, if any.
  TransactionModel? get transactionToEdit => _transactionToEdit;

  /// Whether the right sidebar is expanded.
  bool get isExpanded => _isExpanded;

  /// Starts editing a transaction in the sidebar
  void startEditing(TransactionModel transaction) {
    _transactionToEdit = transaction;
    expand(null);
    notifyListeners();
  }

  /// Cancels editing and clears the transaction
  void cancelEditing() {
    _transactionToEdit = null;
    notifyListeners();
  }

  /// Toggles the expanded state of the right sidebar.
  void toggleExpanded(BuildContext context) {
    _isExpanded = !_isExpanded;

    // On small screens, collapse the left sidebar when expanding this one
    if (_isExpanded) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < SidebarProvider.expandedWidth + expandedWidth) {
        context.read<SidebarProvider>().collapse();
      }
    }

    notifyListeners();
  }

  /// Expands the right sidebar.
  void expand(BuildContext? context) {
    if (!_isExpanded) {
      _isExpanded = true;

      // On small screens, collapse the left sidebar when expanding this one
      if (context != null) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (screenWidth < SidebarProvider.expandedWidth + expandedWidth) {
          context.read<SidebarProvider>().collapse();
        }
      }

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
    // Keep expanded by default on small screens, but ensure left sidebar is collapsed
    if (width < SidebarProvider.expandedWidth + expandedWidth) {
      _isExpanded = true;
      context.read<SidebarProvider>().collapse();
      notifyListeners();
    }
  }
}
