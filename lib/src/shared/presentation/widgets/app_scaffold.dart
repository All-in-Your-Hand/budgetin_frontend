import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sidebar_provider.dart';
import '../providers/right_sidebar_provider.dart';
import 'sidebar.dart';
import 'right_sidebar.dart';
import 'footer.dart';

/// A scaffold widget that provides the main layout structure for the app.
class AppScaffold extends StatefulWidget {
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
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  void initState() {
    super.initState();
    // Schedule the initialization for after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sidebarProvider = context.read<SidebarProvider>();
      final rightSidebarProvider = context.read<RightSidebarProvider>();

      // Initialize both sidebars based on screen size
      sidebarProvider.initializeForScreenSize(context);
      rightSidebarProvider.initializeForScreenSize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Sidebar(currentIndex: widget.currentIndex),
                Expanded(
                  child: widget.body,
                ),
                const RightSidebar(),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
