import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/models/account_request.dart';
import '../providers/account_provider.dart';
import '../../../../core/utils/constant/network_constants.dart';
import '../../../../shared/presentation/widgets/custom_snackbar.dart';

/// A dialog widget for adding or editing accounts.
///
/// This dialog provides a form with fields to create or edit an account.
/// It handles both creation and editing modes based on whether an account is provided.
class AccountDialog extends StatefulWidget {
  /// The account to edit. If null, the dialog will be in creation mode.
  final AccountModel? account;

  /// Creates a new instance of [AccountDialog].
  ///
  /// If [account] is provided, the dialog will be in edit mode and pre-fill
  /// all fields with the account's data. Otherwise, it will be in creation mode.
  const AccountDialog({
    super.key,
    this.account,
  });

  /// Shows the dialog for adding or editing an account.
  ///
  /// This is a convenience method to show the dialog without directly creating
  /// an instance of [AccountDialog].
  static Future<void> show(BuildContext context, {AccountModel? account}) async {
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AccountDialog(account: account),
      );
    }
  }

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _accountNameController;
  late final TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    _accountNameController = TextEditingController(
      text: account?.accountName ?? '',
    );
    _balanceController = TextEditingController(
      text: account?.balance.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context, AccountProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final request = widget.account != null
          ? UpdateAccountRequest(
              account: AccountModel(
                id: widget.account!.id,
                userId: NetworkConstants.testUserId,
                accountName: _accountNameController.text.trim(),
                balance: double.parse(_balanceController.text),
              ),
            )
          : AddAccountRequest(
              userId: NetworkConstants.testUserId,
              accountName: _accountNameController.text.trim(),
              balance: double.parse(_balanceController.text),
            );

      bool success;
      if (widget.account != null) {
        success = await provider.updateAccount(request as UpdateAccountRequest);
      } else {
        success = await provider.addAccount(request as AddAccountRequest);
      }

      if (success) {
        await provider.getAccounts(NetworkConstants.testUserId);
        if (context.mounted) {
          Navigator.pop(context);
          CustomSnackbar.show(
            context: context,
            isSuccess: true,
            message: widget.account != null ? 'Account updated successfully!' : 'Account added successfully!',
          );
        }
      } else if (context.mounted) {
        CustomSnackbar.show(
          context: context,
          isSuccess: false,
          message: provider.error ?? 'Failed to ${widget.account != null ? 'update' : 'add'} account',
        );
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.show(
          context: context,
          isSuccess: false,
          message: 'An unexpected error occurred',
        );
      }
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      widget.account != null ? 'Edit Account' : 'Add Account',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _AccountNameField(controller: _accountNameController),
                  const SizedBox(height: 16),
                  _BalanceField(controller: _balanceController),
                  const SizedBox(height: 24),
                  _ActionButtons(
                    isEditMode: widget.account != null,
                    onSubmit: () => _handleSubmit(context, provider),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A private widget for the account name input field
class _AccountNameField extends StatelessWidget {
  final TextEditingController controller;

  const _AccountNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Account name input field',
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Account Name *',
          border: OutlineInputBorder(),
        ),
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an account name';
          }
          if (value.length > 30) {
            return 'Account name must be less than 30 characters';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

/// A private widget for the balance input field
class _BalanceField extends StatelessWidget {
  final TextEditingController controller;

  const _BalanceField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Initial balance input field',
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Initial Balance *',
          border: OutlineInputBorder(),
          prefixText: '€ ',
        ),
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an initial balance';
          }
          final balance = double.tryParse(value);
          if (balance == null) {
            return 'Please enter a valid number';
          }
          if (balance < 0) {
            return 'Balance cannot be negative';
          }
          if (balance > 999999999999) {
            return 'Balance cannot exceed 999,999,999,999';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

/// A private widget for the action buttons
class _ActionButtons extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onSubmit;

  const _ActionButtons({
    required this.isEditMode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onSubmit,
          child: Text(
            isEditMode ? 'Update Account' : 'Add Account',
          ),
        ),
      ],
    );
  }
}
