import 'package:flutter/material.dart';

/// Provider class for managing the right sidebar state.
class RightSidebarProvider extends ChangeNotifier {
  bool _isExpanded = true;

  /// Whether the right sidebar is expanded.
  bool get isExpanded => _isExpanded;

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
      notifyListeners();
    }
  }
}
