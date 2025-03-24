import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../../../../shared/presentation/widgets/custom_snackbar.dart';

/// A dialog for deleting a transaction.
///
/// This dialog provides a confirmation dialog for deleting a transaction.
/// It handles the deletion of a transaction.
class DeleteTransactionDialog extends StatefulWidget {
  /// The transaction to delete.
  final TransactionModel transaction;

  /// Creates a new instance of [DeleteTransactionDialog].
  const DeleteTransactionDialog({super.key, required this.transaction});

  /// Shows the dialog for deleting a transaction.
  ///
  /// This is a convenience method to show the dialog without directly creating
  /// an instance of [DeleteTransactionDialog].
  static Future<void> show(BuildContext context, {required TransactionModel transaction}) async {
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DeleteTransactionDialog(transaction: transaction),
      );
    }
  }

  @override
  State<DeleteTransactionDialog> createState() => _DeleteTransactionDialogState();
}

class _DeleteTransactionDialogState extends State<DeleteTransactionDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context, TransactionProvider provider) async {
    bool success;
    final userId = context.read<AuthProvider>().user?.userId ?? '';
    success = await provider.deleteTransaction(
      widget.transaction.transactionId,
      userId,
    );
    if (success) {
      await provider.getTransactions(userId);
      if (context.mounted) {
        Navigator.pop(context);
        CustomSnackbar.show(
          context: context,
          isSuccess: true,
          message: 'Transaction deleted successfully!',
        );
      }
    } else if (context.mounted) {
      CustomSnackbar.show(
        context: context,
        isSuccess: false,
        message: 'Failed to delete transaction!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
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
                    'Delete Transaction',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to delete this transaction?',
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              side: const BorderSide(width: 1),
            ),
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: onDelete,
            child: const Text('Delete'),
          ),
        ),
      ],
    );
  }
}
