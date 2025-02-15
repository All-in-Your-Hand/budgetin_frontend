import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/models/transaction_request.dart';
import '../providers/transaction_provider.dart';
import '../../../account/presentation/providers/account_provider.dart';
import '../../../../core/utils/constant/network_constants.dart';

/// A dialog widget for adding or editing transactions.
///
/// This dialog provides a form with all necessary fields to create or edit a transaction.
/// It handles both creation and editing modes based on whether a transaction is provided.
class TransactionDialog extends StatefulWidget {
  /// The transaction to edit. If null, the dialog will be in creation mode.
  final TransactionModel? transaction;

  /// Creates a new instance of [TransactionDialog].
  ///
  /// If [transaction] is provided, the dialog will be in edit mode and pre-fill
  /// all fields with the transaction's data. Otherwise, it will be in creation mode.
  const TransactionDialog({
    Key? key,
    this.transaction,
  }) : super(key: key);

  /// Shows the dialog for adding or editing a transaction.
  ///
  /// This is a convenience method to show the dialog without directly creating
  /// an instance of [TransactionDialog].
  static Future<void> show(BuildContext context,
      {TransactionModel? transaction}) async {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => TransactionDialog(transaction: transaction),
      );
    }
  }

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _toController;
  late final TextEditingController _categoryController;
  late final TextEditingController _accountController;
  late final TextEditingController _amountController;
  late final TextEditingController _typeController;
  late final TextEditingController _notesController;

  // Transaction categories
  static const _categories = [
    'HOUSING',
    'GROCERY',
    'TRANSPORTATION',
    'HEALTHCARE',
    'DINING',
    'SALARY',
    'OTHER',
  ];

  // Transaction types
  static const _transactionTypes = [
    'EXPENSE',
    'INCOME',
  ];

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;
    _dateController = TextEditingController(
      text: transaction != null
          ? DateFormat('dd/MM/yyyy').format(transaction.transactionDate)
          : DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    _toController = TextEditingController(text: transaction?.to ?? '');
    _categoryController =
        TextEditingController(text: transaction?.transactionCategory ?? '');
    _accountController =
        TextEditingController(text: transaction?.accountId ?? '');
    _amountController = TextEditingController(
      text: transaction?.transactionAmount.toString() ?? '',
    );
    _typeController =
        TextEditingController(text: transaction?.transactionType ?? '');
    _notesController =
        TextEditingController(text: transaction?.description ?? '');
  }

  @override
  void dispose() {
    _dateController.dispose();
    _toController.dispose();
    _categoryController.dispose();
    _accountController.dispose();
    _amountController.dispose();
    _typeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(
      BuildContext context, TransactionProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final dateParts = _dateController.text.split('/');
    final selectedDate = DateTime(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]), // day
    );

    bool success;
    if (widget.transaction != null) {
      final updatedTransaction = TransactionModel(
        transactionId: widget.transaction!.transactionId,
        userId: widget.transaction!.userId,
        accountId: _accountController.text,
        transactionType: _typeController.text,
        transactionCategory: _categoryController.text,
        transactionAmount: double.parse(_amountController.text),
        createdAt: widget.transaction!.createdAt,
        transactionDate: selectedDate,
        description: _notesController.text,
        to: _toController.text,
      );

      final updateRequest =
          TransactionUpdateRequest(transaction: updatedTransaction);
      success = await provider.updateTransaction(
          widget.transaction!.transactionId, updateRequest);
    } else {
      final request = TransactionRequest(
        userId: NetworkConstants.testUserId,
        accountId: _accountController.text,
        transactionType: _typeController.text,
        transactionCategory: _categoryController.text,
        transactionAmount: double.parse(_amountController.text),
        transactionDate: selectedDate,
        description: _notesController.text,
        to: _toController.text,
      );

      success = await provider.addTransaction(request);
    }

    if (success) {
      await provider.fetchTransactions(NetworkConstants.testUserId);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.transaction != null
                  ? 'Transaction updated successfully!'
                  : 'Transaction added successfully!',
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
              provider.error ??
                  'Failed to ${widget.transaction != null ? 'update' : 'add'} transaction',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionProvider, AccountProvider>(
      builder: (context, transactionProvider, accountProvider, _) {
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
                    widget.transaction != null
                        ? 'Edit Transaction'
                        : 'Add Transaction',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(context),
                  const SizedBox(height: 16),
                  _buildToField(),
                  const SizedBox(height: 16),
                  _buildCategoryField(transactionProvider),
                  const SizedBox(height: 16),
                  _buildAccountField(accountProvider, transactionProvider),
                  const SizedBox(height: 16),
                  _buildAmountField(transactionProvider),
                  const SizedBox(height: 16),
                  _buildTypeField(transactionProvider),
                  const SizedBox(height: 16),
                  _buildNotesField(),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, transactionProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Date *',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      controller: _dateController,
      readOnly: true,
      validator: (value) =>
          context.read<TransactionProvider>().validateDate(value),
      onTap: () async {
        final currentParts = _dateController.text.split('/');
        final currentDate = DateTime(
          int.parse(currentParts[2]),
          int.parse(currentParts[1]),
          int.parse(currentParts[0]),
        );

        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (picked != null) {
          _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      },
    );
  }

  Widget _buildToField() {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'To (Optional)',
        border: OutlineInputBorder(),
      ),
      controller: _toController,
      maxLength: 30,
    );
  }

  Widget _buildCategoryField(TransactionProvider provider) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Category *',
        border: OutlineInputBorder(),
      ),
      value: _categoryController.text.isEmpty ? null : _categoryController.text,
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      validator: (value) => provider.validateCategory(value),
      onChanged: (value) {
        if (value != null) {
          _categoryController.text = value;
        }
      },
    );
  }

  Widget _buildAccountField(
      AccountProvider accountProvider, TransactionProvider provider) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'From Account *',
        border: OutlineInputBorder(),
      ),
      value: _accountController.text.isEmpty ? null : _accountController.text,
      items: accountProvider.accounts.map((account) {
        return DropdownMenuItem(
          value: account.accountId,
          child: Text(
              '${account.accountName} (Balance: €${account.balance.toStringAsFixed(2)})'),
        );
      }).toList(),
      validator: (value) => provider.validateAccount(value),
      onChanged: (value) {
        if (value != null) {
          _accountController.text = value;
        }
      },
    );
  }

  Widget _buildAmountField(TransactionProvider provider) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Amount *',
        border: OutlineInputBorder(),
        prefixText: '€ ',
      ),
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      validator: (value) => provider.validateAmount(value),
    );
  }

  Widget _buildTypeField(TransactionProvider provider) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Transaction Type *',
        border: OutlineInputBorder(),
      ),
      value: _typeController.text.isEmpty ? null : _typeController.text,
      items: _transactionTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      validator: (value) => provider.validateTransactionType(value),
      onChanged: (value) {
        if (value != null) {
          _typeController.text = value;
        }
      },
    );
  }

  Widget _buildNotesField() {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Notes (Optional)',
        border: OutlineInputBorder(),
        counterText: '',
      ),
      controller: _notesController,
      maxLines: 3,
      maxLength: 150,
    );
  }

  Widget _buildActionButtons(
      BuildContext context, TransactionProvider provider) {
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
          child: Text(widget.transaction != null
              ? 'Update Transaction'
              : 'Add Transaction'),
        ),
      ],
    );
  }
}
