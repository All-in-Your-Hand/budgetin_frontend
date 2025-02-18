import 'package:flutter/material.dart';
import 'account_dialog.dart';

/// A card widget that displays an "Add Account" button styled like an account card
class AddAccountCard extends StatelessWidget {
  /// Creates a new instance of [AddAccountCard]
  const AddAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Semantics(
        button: true,
        label: 'Add new account',
        child: InkWell(
          onTap: () => AccountDialog.show(context),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final iconSize = (constraints.maxWidth * 0.15).clamp(24.0, 40.0); // Constrain icon size
              return Center(
                child: Icon(
                  Icons.add,
                  size: iconSize,
                  color: Colors.grey,
                  semanticLabel: 'Add account button',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
