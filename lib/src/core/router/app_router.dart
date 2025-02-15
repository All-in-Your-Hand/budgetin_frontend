import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/transaction/presentation/pages/transaction_page.dart';
import '../../features/account/presentation/pages/accounts_page.dart';

/// Custom page transition that fades between pages
CustomTransitionPage<void> _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

/// The router configuration for the app.
final router = GoRouter(
  initialLocation: '/transactions',
  routes: [
    GoRoute(
      path: '/transactions',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const TransactionPage(),
      ),
    ),
    GoRoute(
      path: '/accounts',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const AccountsPage(),
      ),
    ),
  ],
);
