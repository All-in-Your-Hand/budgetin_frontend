import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'BudgetIn',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Cursive',
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _SidebarItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            isSelected: currentIndex == 0,
            onTap: () {},
            isEnabled: false,
          ),
          _SidebarItem(
            icon: Icons.receipt_long_outlined,
            label: 'Transactions',
            isSelected: currentIndex == 1,
            onTap: () => context.go('/transactions'),
          ),
          _SidebarItem(
            icon: Icons.sync_outlined,
            label: 'Recurring',
            isSelected: currentIndex == 2,
            onTap: () {},
            isEnabled: false,
          ),
          _SidebarItem(
            icon: Icons.account_balance_outlined,
            label: 'Accounts',
            isSelected: currentIndex == 3,
            onTap: () => context.go('/accounts'),
          ),
          _SidebarItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isSelected: currentIndex == 4,
            onTap: () {},
            isEnabled: false,
          ),
        ],
      ),
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
    this.isEnabled = true,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final color = isEnabled
        ? (isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface)
        : Theme.of(context).colorScheme.onSurface.withAlpha(128);

    return Material(
      color: Colors.transparent,
      child: ListTile(
        enabled: isEnabled,
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color,
              ),
        ),
        selected: isSelected,
        onTap: onTap,
        selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(128),
      ),
    );
  }
}
