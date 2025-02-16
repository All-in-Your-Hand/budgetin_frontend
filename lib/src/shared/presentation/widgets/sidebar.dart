import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/sidebar_provider.dart';

/// A sidebar widget that provides navigation options for the app.
class Sidebar extends StatelessWidget {
  /// Creates a new instance of [Sidebar].
  const Sidebar({
    super.key,
    required this.currentIndex,
  });

  /// The currently selected index in the sidebar.
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<SidebarProvider>(
      builder: (context, provider, _) {
        final isCollapsed = provider.isCollapsed;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isCollapsed ? 70 : 250,
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              // Header section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCollapsed ? 0 : 16,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isCollapsed)
                      Expanded(
                        child: Text(
                          'BudgetIn',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontFamily: 'Cursive',
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    AnimatedRotation(
                      turns: isCollapsed ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left),
                        color: Theme.of(context).colorScheme.onSurface,
                        onPressed: () => provider.toggleCollapsed(),
                        tooltip: isCollapsed ? 'Expand' : 'Collapse',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
              // Navigation items section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SidebarItem(
                        icon: Icons.dashboard_outlined,
                        label: 'Dashboard',
                        isSelected: currentIndex == 0,
                        onTap: () {},
                        isEnabled: false,
                        isCollapsed: isCollapsed,
                      ),
                      _SidebarItem(
                        icon: Icons.receipt_long_outlined,
                        label: 'Transactions',
                        isSelected: currentIndex == 1,
                        onTap: () => context.go('/transactions'),
                        isCollapsed: isCollapsed,
                      ),
                      _SidebarItem(
                        icon: Icons.sync_outlined,
                        label: 'Recurring',
                        isSelected: currentIndex == 2,
                        onTap: () {},
                        isEnabled: false,
                        isCollapsed: isCollapsed,
                      ),
                      _SidebarItem(
                        icon: Icons.account_balance_outlined,
                        label: 'Accounts',
                        isSelected: currentIndex == 3,
                        onTap: () => context.go('/accounts'),
                        isCollapsed: isCollapsed,
                      ),
                      _SidebarItem(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        isSelected: currentIndex == 4,
                        onTap: () {},
                        isEnabled: false,
                        isCollapsed: isCollapsed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A single item in the sidebar menu.
class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isCollapsed,
    this.isEnabled = true,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    final color = isEnabled
        ? (isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface)
        : Theme.of(context).colorScheme.onSurface.withAlpha(128);

    return Tooltip(
      message: isCollapsed ? label : '',
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          enabled: isEnabled,
          leading: isCollapsed
              ? null
              : Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
          title: isCollapsed
              ? Center(
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                )
              : Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: color,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
          selected: isSelected,
          onTap: onTap,
          selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(128),
          horizontalTitleGap: isCollapsed ? 0 : 16,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 0 : 16,
            vertical: 4,
          ),
          minLeadingWidth: isCollapsed ? 0 : 40,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
