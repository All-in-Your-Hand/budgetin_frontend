import 'package:flutter/material.dart';
import 'sidebar.dart';

/// A scaffold widget that provides the main layout structure for the app.
class AppScaffold extends StatelessWidget {
  /// Creates a new instance of [AppScaffold].
  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  /// The main content to display in the scaffold.
  final Widget body;

  /// The currently selected index in the sidebar.
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentIndex: currentIndex),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
