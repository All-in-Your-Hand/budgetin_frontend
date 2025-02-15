import 'package:budgetin_frontend/src/core/utils/constant/network_constants.dart';
// TODO: Implement proper logging with app_logger
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_table.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/models/transaction_request.dart';
import 'package:budgetin_frontend/src/features/account/presentation/providers/account_provider.dart';
// import '../../../account/presentation/providers/account_provider.dart';

/// A page that displays a list of user transactions.
///
/// This page automatically fetches and displays transactions for the current user.
/// It handles loading states and error states appropriately, providing feedback
/// to the user about the current state of the data.
class TransactionPage extends StatefulWidget {
  /// Creates a new instance of [TransactionPage].
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Initiates the transaction fetching process.
  ///
  /// This method is called after the widget is inserted into the widget tree.
  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const userId =
          NetworkConstants.testUserId; // TODO: Get from auth provider
      if (mounted) {
        context.read<TransactionProvider>().fetchTransactions(userId);
        context.read<AccountProvider>().getAccounts(userId);
      }
    });
  }

  /// Shows the dialog for adding a new transaction.
  ///
  /// This method handles the UI for transaction creation, delegating the actual
  /// data processing to the [TransactionProvider].
  void _showAddTransactionDialog() {
    final formKey = GlobalKey<FormState>();
    final dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    final toController = TextEditingController();
    final categoryController = TextEditingController();
    final accountController = TextEditingController();
    final amountController = TextEditingController();
    final typeController = TextEditingController();
    final notesController = TextEditingController();

    // Temporary Transaction categories // TODO: Replace with actual categories
    const categories = [
      'HOUSING',
      'GROCERY',
      'TRANSPORTATION',
      'HEALTHCARE',
      'DINING',
      'SALARY',
      'OTHER',
    ];

    // Transaction types
    const transactionTypes = [
      'Expense',
      'Income',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Transaction',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        semanticsLabel: 'Add Transaction Form Title',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Date *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: dateController,
                        readOnly: true,
                        validator: (value) => context
                            .read<TransactionProvider>()
                            .validateDate(value),
                        onTap: () async {
                          // Parse current date to get initial date
                          final currentParts = dateController.text.split('/');
                          final currentDate = DateTime(
                            int.parse(currentParts[2]), // year
                            int.parse(currentParts[1]), // month
                            int.parse(currentParts[0]), // day
                          );

                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: currentDate,
                            firstDate: DateTime(2000),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            // Update only the date part, keeping the current time
                            dateController.text =
                                DateFormat('dd/MM/yyyy').format(picked);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'To (Optional)',
                          border: OutlineInputBorder(),
                        ),
                        controller: toController,
                        maxLength: 30,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category *',
                          border: OutlineInputBorder(),
                        ),
                        value: categoryController.text.isEmpty
                            ? null
                            : categoryController.text,
                        items: categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        validator: (value) => context
                            .read<TransactionProvider>()
                            .validateCategory(value),
                        onChanged: (String? value) {
                          if (value != null) {
                            categoryController.text = value;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'From Account *',
                          border: OutlineInputBorder(),
                        ),
                        value: accountController.text.isEmpty
                            ? null
                            : accountController.text,
                        items: context
                            .watch<AccountProvider>()
                            .accounts
                            .map((account) {
                          return DropdownMenuItem<String>(
                            value: account.accountId,
                            child: Text(
                                '${account.accountName} (Balance: €${account.balance.toStringAsFixed(2)})'),
                          );
                        }).toList(),
                        validator: (value) => context
                            .read<TransactionProvider>()
                            .validateAccount(value),
                        onChanged: (String? value) {
                          if (value != null) {
                            accountController.text = value;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Amount *',
                          border: OutlineInputBorder(),
                          prefixText: '€ ',
                        ),
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) => context
                            .read<TransactionProvider>()
                            .validateAmount(value),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Transaction Type *',
                          border: OutlineInputBorder(),
                        ),
                        value: typeController.text.isEmpty
                            ? null
                            : typeController.text,
                        items: transactionTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        validator: (value) => context
                            .read<TransactionProvider>()
                            .validateTransactionType(value),
                        onChanged: (String? value) {
                          if (value != null) {
                            typeController.text = value;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Notes (Optional)',
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                        controller: notesController,
                        maxLines: 3,
                        maxLength: 150,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final provider =
                                    context.read<TransactionProvider>();

                                // Parse the date from dd/MM/yyyy to DateTime
                                final dateParts =
                                    dateController.text.split('/');
                                final selectedDate = DateTime(
                                  int.parse(dateParts[2]), // year
                                  int.parse(dateParts[1]), // month
                                  int.parse(dateParts[0]), // day
                                  0, // hour
                                  0, // minute
                                  0, // second
                                  0, // millisecond
                                );

                                final request = TransactionRequest(
                                  userId: NetworkConstants.testUserId,
                                  accountId: accountController.text,
                                  transactionType:
                                      typeController.text.toUpperCase(),
                                  transactionCategory: categoryController.text,
                                  transactionAmount:
                                      double.parse(amountController.text),
                                  transactionDate: selectedDate,
                                  description: notesController.text,
                                  to: toController.text,
                                );

                                final success =
                                    await provider.addTransaction(request);

                                if (success) {
                                  // Show success message and close dialog
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Transaction added successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(context);

                                    // Refresh the transaction list
                                    await provider.fetchTransactions(
                                        NetworkConstants.testUserId);
                                  }
                                } else {
                                  // Show error message
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(provider.error ??
                                            'Failed to add transaction'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: const Text('Add Transaction'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transactions',
          semanticsLabel: 'Transactions Page Title',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
            tooltip: 'Refresh Transactions',
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _fetchData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TransactionTable(
              transactions: provider.transactions,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        tooltip: 'Add new transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}
