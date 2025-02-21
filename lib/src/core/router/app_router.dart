import 'package:budgetin_frontend/src/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/transaction/presentation/pages/transaction_page.dart';
import '../../features/account/presentation/pages/accounts_page.dart';
import '../exceptions/route_exception.dart';
import '../utils/log/app_logger.dart';

/// Custom page transition that fades between pages
///
/// [context] The build context
/// [state] The router state
/// [child] The widget to be displayed
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

/// Error page shown when no route matches
class RouteErrorPage extends StatelessWidget {
  /// Creates a route error page
  const RouteErrorPage({super.key, required this.error});

  /// The error that occurred during routing
  final Exception error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error.toString()),
      ),
    );
  }
}

/// The router configuration for the app.
///
/// Defines the routing table and handles navigation between different pages.
/// Uses custom transition animations for smooth page transitions.
final GoRouter router = GoRouter(
  initialLocation: '/transactions',
  errorBuilder: (context, state) {
    final error = state.error;
    if (error != null) {
      final routeException = RouteException('Route not found: ${state.uri.path}', error);
      AppLogger.error('Router', routeException.toString());
      return RouteErrorPage(error: routeException);
    }

    const routeException = RouteException('Unknown routing error occurred');
    AppLogger.error('Router', routeException.toString());
    return const RouteErrorPage(error: routeException);
  },
  routes: [
    GoRoute(
      path: '/signup',
      name: 'signup',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SignUpPage(),
      ),
    ),
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const TransactionPage(),
      ),
    ),
    GoRoute(
      path: '/accounts',
      name: 'accounts',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const AccountsPage(),
      ),
    ),
  ],
);
