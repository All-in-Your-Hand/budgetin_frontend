import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/sidebar_provider.dart';
import '../../../features/authentication/presentation/providers/auth_provider.dart';

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
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: isCollapsed ? 85 : 300,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFF1F6F6),
                Color.fromARGB(158, 178, 192, 192),
              ],
              stops: [0.98, 1],
            ),
          ),
          child: Column(
            children: [
              // Header section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCollapsed ? 16 : 16,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isCollapsed)
                      Expanded(
                        child: Center(
                          child: Text(
                            'BudgetIn',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontFamily: 'Lexend',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    AnimatedRotation(
                      turns: isCollapsed ? -0.5 : 0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left),
                        color: Theme.of(context).colorScheme.onSurface,
                        onPressed: () => provider.toggleCollapsed(context),
                        tooltip: isCollapsed ? 'Expand' : 'Collapse',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
              // Navigation items section
              const Divider(
                color: Color.fromARGB(158, 178, 192, 192),
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
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
              ),
              const Divider(
                color: Color.fromARGB(158, 178, 192, 192),
                thickness: 1,
              ),
              _SidebarItem(
                icon: Icons.logout_outlined,
                label: 'Logout',
                isSelected: false,
                onTap: () async {
                  await context.read<AuthProvider>().signOut();
                  if (context.mounted) {
                    context.go('/signin');
                  }
                },
                isCollapsed: isCollapsed,
              ),
              const SizedBox(height: 8),
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
      message: isCollapsed ? (isEnabled ? label : 'Coming soon!') : (isEnabled ? '' : 'Coming soon!'),
      child: Material(
        child: ListTile(
          dense: true,
          enabled: isEnabled,
          leading: isCollapsed
              ? null
              : Opacity(
                  opacity: isEnabled ? 1 : 0.85,
                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),
          title: isCollapsed
              ? Center(
                  child: Opacity(
                    opacity: isEnabled ? 1 : 0.85,
                    child: Icon(
                      icon,
                      color: color,
                      size: 32,
                    ),
                  ),
                )
              : Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: color,
                        fontSize: 20,
                        fontFamily: 'Lexend',
                        fontWeight: isSelected ? FontWeight.w300 : FontWeight.w200,
                        height: 1.5,
                        letterSpacing: -0.8,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
          selected: isSelected,
          onTap: onTap,
          selectedTileColor: Theme.of(context).colorScheme.primary.withAlpha(25),
          tileColor: const Color(0xFFF1F6F6),
          horizontalTitleGap: isCollapsed ? 0 : 12,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 0 : 12,
            vertical: 4,
          ),
          minLeadingWidth: isCollapsed ? 0 : 36,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
