import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_model.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../features/authentication/presentation/providers/auth_provider.dart';
import '../../../features/transaction/presentation/providers/transaction_provider.dart';
import '../../../features/account/presentation/providers/account_provider.dart';
import '../providers/right_sidebar_provider.dart';
import './custom_snackbar.dart';

/// A right sidebar widget that provides a form for adding new transactions.
/// This widget slides in and out from the right side of the screen and contains
/// a form with fields for transaction details such as date, amount, category, etc.
class RightSidebar extends StatefulWidget {
  const RightSidebar({Key? key}) : super(key: key);

  @override
  State<RightSidebar> createState() => _RightSidebarState();
}

/// The state for the [RightSidebar] widget.
class _RightSidebarState extends State<RightSidebar> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _toController;
  late final TextEditingController _categoryController;
  late final TextEditingController _accountController;
  late final TextEditingController _amountController;
  late final TextEditingController _typeController;
  late final TextEditingController _notesController;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

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
    _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    _toController = TextEditingController();
    _categoryController = TextEditingController();
    _accountController = TextEditingController();
    _amountController = TextEditingController();
    _typeController = TextEditingController();
    _notesController = TextEditingController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _populateFormFields(TransactionModel transaction) {
    _dateController.text = DateFormat('dd/MM/yyyy').format(transaction.transactionDate);
    _toController.text = transaction.to;
    _categoryController.text = transaction.transactionCategory;
    _accountController.text = transaction.accountId;
    _amountController.text = transaction.transactionAmount.toString();
    _typeController.text = transaction.transactionType;
    _notesController.text = transaction.description;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initial population of form fields if editing
    final transaction = context.read<RightSidebarProvider>().transactionToEdit;
    if (transaction != null) {
      _populateFormFields(transaction);
    }
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
    _animationController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _toController.clear();
    _categoryController.clear();
    _accountController.clear();
    _amountController.clear();
    _typeController.clear();
    _notesController.clear();
  }

  Future<void> _handleSubmit(BuildContext context, TransactionProvider provider, AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final dateParts = _dateController.text.split('/');
    final rightSidebarProvider = context.read<RightSidebarProvider>();
    final editingTransaction = rightSidebarProvider.transactionToEdit;

    final selectedDate = DateTime(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]), // day
      editingTransaction?.createdAt.hour ?? DateTime.now().hour,
      editingTransaction?.createdAt.minute ?? DateTime.now().minute,
      editingTransaction?.createdAt.second ?? DateTime.now().second,
    );

    bool success;
    if (editingTransaction != null) {
      final updatedTransaction = TransactionModel(
        transactionId: editingTransaction.transactionId,
        userId: editingTransaction.userId,
        accountId: _accountController.text,
        transactionType: _typeController.text,
        transactionCategory: _categoryController.text,
        transactionAmount: double.parse(_amountController.text),
        createdAt: editingTransaction.createdAt,
        transactionDate: selectedDate,
        description: _notesController.text,
        to: _toController.text,
      );

      final updateRequest = UpdateTransactionRequest(transaction: updatedTransaction);
      success = await provider.updateTransaction(updateRequest);
    } else {
      final request = AddTransactionRequest(
        userId: authProvider.user?.userId ?? '',
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
      await provider.getTransactions(authProvider.user?.userId ?? '');
      await context.read<AccountProvider>().getAccounts(authProvider.user?.userId ?? '');
      if (context.mounted) {
        _clearForm();
        rightSidebarProvider.cancelEditing();
        CustomSnackbar.show(
          context: context,
          isSuccess: true,
          message: editingTransaction != null ? 'Transaction updated successfully!' : 'Transaction added successfully!',
        );
      }
    } else {
      if (context.mounted) {
        CustomSnackbar.show(
          context: context,
          isSuccess: false,
          message: provider.error ?? 'Failed to ${editingTransaction != null ? 'update' : 'add'} transaction',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RightSidebarProvider>(
      builder: (context, rightSidebarProvider, _) {
        if (rightSidebarProvider.isExpanded) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }

        // Handle form population when transaction to edit changes
        final transaction = rightSidebarProvider.transactionToEdit;
        if (transaction != null) {
          _populateFormFields(transaction);
        }

        return Row(
          children: [
            Material(
              child: InkWell(
                onTap: () => rightSidebarProvider.toggleExpanded(context),
                child: Container(
                  width: 24,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    rightSidebarProvider.isExpanded ? Icons.chevron_right : Icons.chevron_left,
                    size: 20,
                  ),
                ),
              ),
            ),
            SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: _animation,
              child: Container(
                width: 320,
                color: Theme.of(context).colorScheme.surface,
                child: Consumer3<TransactionProvider, AccountProvider, AuthProvider>(
                  builder: (context, transactionProvider, accountProvider, authProvider, _) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Center(
                                child: SizedBox(
                                  width: 280,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                rightSidebarProvider.isEditing ? 'Edit Transaction' : 'Add Transaction',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
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
                                          Row(
                                            children: [
                                              if (rightSidebarProvider.isEditing) ...[
                                                OutlinedButton(
                                                  onPressed: () {
                                                    _clearForm();
                                                    rightSidebarProvider.cancelEditing();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                const SizedBox(width: 12),
                                              ],
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      _handleSubmit(context, transactionProvider, authProvider),
                                                  child: Text(
                                                    rightSidebarProvider.isEditing
                                                        ? 'Update Transaction'
                                                        : 'Add Transaction',
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Semantics(
      label: 'Transaction date input field',
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Date *',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        controller: _dateController,
        readOnly: true,
        validator: (value) => context.read<TransactionProvider>().validateDate(value),
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
      ),
    );
  }

  Widget _buildToField() {
    return Semantics(
      label: 'Transaction recipient input field',
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'To (Optional)',
          border: OutlineInputBorder(),
        ),
        controller: _toController,
        maxLength: 30,
      ),
    );
  }

  Widget _buildCategoryField(TransactionProvider provider) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Category *',
        border: OutlineInputBorder(),
      ),
      value: _categoryController.text.isEmpty ? null : _categoryController.text,
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(
            category,
            overflow: TextOverflow.ellipsis,
          ),
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

  Widget _buildAccountField(AccountProvider accountProvider, TransactionProvider provider) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'From Account *',
        border: OutlineInputBorder(),
      ),
      value: _accountController.text.isEmpty ? null : _accountController.text,
      items: accountProvider.accounts.map((account) {
        return DropdownMenuItem(
          value: account.id,
          child: Text(
            '${account.accountName} (€${account.balance.toStringAsFixed(2)})',
            overflow: TextOverflow.ellipsis,
          ),
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
    return Semantics(
      label: 'Transaction amount input field',
      child: TextFormField(
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
      ),
    );
  }

  Widget _buildTypeField(TransactionProvider provider) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Transaction Type *',
        border: OutlineInputBorder(),
      ),
      value: _typeController.text.isEmpty ? null : _typeController.text,
      items: _transactionTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(
            type,
            overflow: TextOverflow.ellipsis,
          ),
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
    return Semantics(
      label: 'Transaction notes input field',
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Notes (Optional)',
          border: OutlineInputBorder(),
          counterText: '',
        ),
        controller: _notesController,
        maxLines: 3,
        maxLength: 150,
      ),
    );
  }
}
