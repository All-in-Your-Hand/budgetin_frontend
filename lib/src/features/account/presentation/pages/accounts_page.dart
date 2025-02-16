import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/presentation/widgets/app_scaffold.dart';
import '../providers/account_provider.dart';
import '../widgets/account_card.dart';
import '../widgets/add_account_card.dart';
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
    return AppScaffold(
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AccountProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Text(
                  provider.error!,
                  style: TextStyle(color: Colors.red),
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

                    return Align(
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
                        itemCount: hasAccounts ? accounts.length + 1 : 1,
                        itemBuilder: (context, index) {
                          // If there are no accounts, show AddAccountCard as the only item
                          if (!hasAccounts) {
                            return const AddAccountCard();
                          }

                          // If this is the last item, show AddAccountCard
                          if (index == accounts.length) {
                            return const AddAccountCard();
                          }

                          // Otherwise show the account card
                          return AccountCard(account: accounts[index]);
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
