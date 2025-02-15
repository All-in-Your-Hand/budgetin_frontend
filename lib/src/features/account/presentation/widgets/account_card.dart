import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Implement account details/edit functionality
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      account.accountName,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      // TODO: Implement edit and delete functionality
                    },
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '\$${account.balance.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
