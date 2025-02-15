import 'package:flutter/material.dart';
import '../../../../common/presentation/widgets/app_scaffold.dart';

/// The accounts page that displays user's financial accounts.
class AccountsPage extends StatelessWidget {
  /// Creates a new instance of [AccountsPage].
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      currentIndex: 3,
      body: Center(
        child: Text('Accounts Page - Coming Soon'),
      ),
    );
  }
}
