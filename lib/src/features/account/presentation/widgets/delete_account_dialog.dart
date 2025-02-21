import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../../../../core/utils/constant/network_constants.dart';
import '../../../../shared/presentation/widgets/custom_snackbar.dart';

// A dialog for deleting an account.
///
/// This dialog provides a confirmation dialog for deleting an account.
/// It handles the deletion of an account.
class DeleteAccountDialog extends StatefulWidget {
  /// The account to delete.
  final AccountModel account;

  /// Creates a new instance of [DeleteAccountDialog].
  const DeleteAccountDialog({super.key, required this.account});

  /// Shows the dialog for deleting an account.
  ///
  /// This is a convenience method to show the dialog without directly creating
  /// an instance of [DeleteAccountDialog].
  static Future<void> show(BuildContext context, {required AccountModel account}) async {
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DeleteAccountDialog(account: account),
      );
    }
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context, AccountProvider provider) async {
    bool success;
    success = await provider.deleteAccount(widget.account.id);
    if (success) {
      await provider.getAccounts(NetworkConstants.testUserId);
      if (context.mounted) {
        Navigator.pop(context);
        CustomSnackbar.show(
          context: context,
          isSuccess: true,
          message: 'Account deleted successfully!',
        );
      }
    } else if (context.mounted) {
      CustomSnackbar.show(
        context: context,
        isSuccess: false,
        message: 'Failed to delete account!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, provider, _) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to delete this account?',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                _ActionButtons(
                  onCancel: () => Navigator.pop(context),
                  onDelete: () => _handleSubmit(context, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A private widget for the action buttons
class _ActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const _ActionButtons({
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: TextButton(onPressed: onCancel, child: const Text('Cancel'))),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton(
            onPressed: onDelete,
            child: const Text('Delete'),
          ),
        ),
      ],
    );
  }
}
