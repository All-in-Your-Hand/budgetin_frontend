import 'package:budgetin_frontend/src/features/account/domain/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/models/account_request.dart';
import '../providers/account_provider.dart';
import '../../../../core/utils/constant/network_constants.dart';

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
    Key? key,
    this.account,
  }) : super(key: key);

  /// Shows the dialog for adding or editing an account.
  ///
  /// This is a convenience method to show the dialog without directly creating
  /// an instance of [AccountDialog].
  static Future<void> show(BuildContext context, {AccountModel? account}) async {
    if (context.mounted) {
      await showDialog(
        context: context,
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

    final request = widget.account != null
        ? AccountUpdateRequest(
            account: AccountModel(
              id: widget.account!.id,
              userId: NetworkConstants.testUserId,
              accountName: _accountNameController.text,
              balance: double.parse(_balanceController.text),
            ),
          )
        : AddAccountRequest(
            userId: NetworkConstants.testUserId,
            accountName: _accountNameController.text,
            balance: double.parse(_balanceController.text),
          );

    bool success;
    if (widget.account != null) {
      success = await provider.updateAccount(request as AccountUpdateRequest);
    } else {
      success = await provider.addAccount(request as AddAccountRequest);
    }

    if (success) {
      await provider.getAccounts(NetworkConstants.testUserId);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.account != null ? 'Account updated successfully!' : 'Account added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.error ?? 'Failed to ${widget.account != null ? 'update' : 'add'} account',
            ),
            backgroundColor: Colors.red,
          ),
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
                  Text(
                    widget.account != null ? 'Edit Account' : 'Add Account',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAccountNameField(provider),
                  const SizedBox(height: 16),
                  _buildBalanceField(provider),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountNameField(AccountProvider provider) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Account Name *',
        border: OutlineInputBorder(),
      ),
      controller: _accountNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an account name';
        }
        if (value.length > 30) {
          return 'Account name must be less than 30 characters';
        }
        return null;
      },
    );
  }

  Widget _buildBalanceField(AccountProvider provider) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Initial Balance *',
        border: OutlineInputBorder(),
        prefixText: '€ ',
      ),
      controller: _balanceController,
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
        return null;
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, AccountProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _handleSubmit(context, provider),
          child: Text(
            widget.account != null ? 'Update Account' : 'Add Account',
          ),
        ),
      ],
    );
  }
}
