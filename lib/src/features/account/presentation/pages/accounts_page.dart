import 'package:budgetin_frontend/src/features/account/presentation/widgets/account_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/presentation/widgets/app_scaffold.dart';
import '../providers/account_provider.dart';
import '../widgets/account_card.dart';
import '../../../../core/utils/constant/network_constants.dart';

/// The accounts page that displays user's financial accounts.
class AccountsPage extends StatefulWidget {
  /// Creates a new instance of [AccountsPage].
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    super.initState();
    // TODO: Replace with actual user ID from auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().getAccounts(NetworkConstants.testUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Accounts',
                  style: theme.textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () => AccountDialog.show(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Account'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<AccountProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Text(
                        provider.error!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  if (provider.accounts.isEmpty) {
                    return Center(
                      child: Text(
                        'No accounts found. Add your first account!',
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.0,
                    ),
                    itemCount: provider.accounts.length,
                    itemBuilder: (context, index) {
                      final account = provider.accounts[index];
                      return AccountCard(account: account);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
