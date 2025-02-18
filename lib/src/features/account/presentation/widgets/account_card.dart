import 'package:budgetin_frontend/src/features/account/presentation/providers/account_provider.dart';
import 'package:budgetin_frontend/src/features/account/presentation/widgets/account_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/account_model.dart';

/// A card widget that displays account information
class AccountCard extends StatelessWidget {
  /// The account model containing the information to display
  final AccountModel account;

  /// Creates a new instance of [AccountCard]
  const AccountCard({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          AccountDialog.show(context, account: account);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final theme = Theme.of(context);
            // Calculate constrained font sizes
            final titleSize = (constraints.maxWidth * 0.05).clamp(12.0, 16.0);
            final balanceSize = (constraints.maxWidth * 0.08).clamp(16.0, 24.0);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          account.accountName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: titleSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                          semanticsLabel: 'Account name: ${account.accountName}',
                        ),
                      ),
                      PopupMenuButton<String>(
                        tooltip: 'Account options',
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            AccountDialog.show(context, account: account);
                          } else if (value == 'delete') {
                            context.read<AccountProvider>().deleteAccount(account.id);
                          }
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '\$${account.balance.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: balanceSize,
                      ),
                      semanticsLabel: 'Balance: ${account.balance.toStringAsFixed(2)} dollars',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
