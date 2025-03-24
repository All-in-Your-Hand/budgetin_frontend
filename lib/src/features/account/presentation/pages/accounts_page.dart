import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/presentation/widgets/app_scaffold.dart';
import '../../../../shared/presentation/widgets/web_responsive_layout.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../providers/account_provider.dart';
import '../widgets/account_card.dart';
import '../widgets/add_account_card.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccounts();
    });
  }

  /// Loads or reloads the accounts for the current user
  Future<void> _loadAccounts() async {
    if (!mounted) return;
    await context.read<AccountProvider>().getAccounts(context.read<AuthProvider>().user?.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 3,
      body: RefreshIndicator(
        onRefresh: _loadAccounts,
        child: WebResponsiveLayout(
          useFullWidth: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<AccountProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Loading accounts',
                    ),
                  );
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                          semanticsLabel: 'Error loading accounts',
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadAccounts,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final accounts = provider.accounts;
                final hasAccounts = accounts.isNotEmpty;

                return Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    if (!hasAccounts)
                      const Positioned.fill(
                        child: Center(
                          child: Text(
                            'No accounts found. Add your first account!',
                            style: TextStyle(fontSize: 16),
                            semanticsLabel: 'No accounts message',
                          ),
                        ),
                      ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate number of columns based on width
                        final crossAxisCount = (constraints.maxWidth / 350).floor();
                        // Calculate the optimal width for each card
                        final cardWidth = constraints.maxWidth / (crossAxisCount > 0 ? crossAxisCount : 1);
                        // Adjust aspect ratio based on card width to maintain reasonable height
                        final aspectRatio = cardWidth > 400 ? 2.5 : (cardWidth > 300 ? 2.0 : 1.6);

                        return Semantics(
                          label: 'Accounts grid view',
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount > 0 ? crossAxisCount : 1,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: aspectRatio,
                              ),
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: accounts.length + 1,
                              itemBuilder: (context, index) {
                                // Always show AddAccountCard as the first item
                                if (index == 0) {
                                  return const AddAccountCard();
                                }

                                // Show account cards after the AddAccountCard
                                return AccountCard(account: accounts[index - 1]);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
