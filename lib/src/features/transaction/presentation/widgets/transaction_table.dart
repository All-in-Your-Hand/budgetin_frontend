import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/models/transaction_model.dart';
import '../providers/transaction_table_provider.dart';
import '../providers/transaction_provider.dart';
import '../../../account/presentation/providers/account_provider.dart';
import '../../../../core/utils/constant/network_constants.dart';
import '../widgets/transaction_dialog.dart';

/// A widget that displays transaction data in a sortable and filterable table format.
///
/// This widget takes a list of [TransactionModel] objects and presents them in a
/// data table with sorting capabilities for each column and filtering options.
/// It uses a separate provider ([TransactionTableProvider]) to manage the table state.
class TransactionTable extends StatelessWidget {
  /// The list of transactions to display in the table.
  final List<TransactionModel> transactions;

  /// Creates a new instance of [TransactionTable].
  ///
  /// The [transactions] parameter is required and must not be null.
  const TransactionTable({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          TransactionTableProvider()..initializeTransactions(transactions),
      child: const _TransactionTableView(),
    );
  }
}

/// The internal implementation of the transaction table view.
///
/// This widget is responsible for rendering the actual table and filter UI.
/// It's private because it's an implementation detail of [TransactionTable].
class _TransactionTableView extends StatelessWidget {
  const _TransactionTableView({Key? key}) : super(key: key);

  /// Gets the account name for a given transaction, returning "(Deleted Account)" if not found.
  ///
  /// This helper method encapsulates the logic for looking up an account name by ID.
  /// It's used for both displaying and sorting the account column.
  String _getAccountName(String accountId, AccountProvider accountProvider) {
    return accountProvider.accounts
            .where((account) => account.accountId == accountId)
            .map((account) => account.accountName)
            .firstOrNull ??
        '(Deleted Account)';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TransactionTableProvider, TransactionProvider,
        AccountProvider>(
      builder:
          (context, tableProvider, transactionProvider, accountProvider, _) {
        if (transactionProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (transactionProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${transactionProvider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => transactionProvider.fetchTransactions(
                      NetworkConstants
                          .testUserId), // TODO: Get from auth provider
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (tableProvider.transactions.isEmpty) {
          return const Center(
            child: Text('No transactions found'),
          );
        }

        return Column(
          children: [
            _buildFilters(context, tableProvider),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    sortColumnIndex: tableProvider.sortColumnIndex,
                    sortAscending: tableProvider.sortAscending,
                    columns: _buildColumns(tableProvider, accountProvider),
                    rows: _buildRows(context, tableProvider, accountProvider),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the column definitions for the data table.
  List<DataColumn> _buildColumns(
      TransactionTableProvider provider, AccountProvider accountProvider) {
    return [
      _buildSortableColumn<DateTime>(
        'Date',
        provider,
        (transaction) => transaction.transactionDate,
      ),
      _buildSortableColumn<String>(
        'Account',
        provider,
        (transaction) =>
            _getAccountName(transaction.accountId, accountProvider),
      ),
      _buildSortableColumn<String>(
        'To',
        provider,
        (transaction) => transaction.to,
      ),
      _buildSortableColumn<num>(
        'Amount',
        provider,
        (transaction) => transaction.transactionAmount,
      ),
      _buildSortableColumn<String>(
        'Category',
        provider,
        (transaction) => transaction.transactionCategory,
      ),
      _buildSortableColumn<String>(
        'Type',
        provider,
        (transaction) => transaction.transactionType,
      ),
      _buildSortableColumn<String>(
        'Description',
        provider,
        (transaction) => transaction.description,
      ),
      const DataColumn(label: Text('Actions')),
    ];
  }

  /// Creates a sortable column with the given parameters.
  DataColumn _buildSortableColumn<T extends Comparable<T>>(
    String label,
    TransactionTableProvider provider,
    T Function(TransactionModel) selector,
  ) {
    return DataColumn(
      label: Text(label),
      onSort: (columnIndex, _) {
        provider.sort<T>(selector, columnIndex);
      },
    );
  }

  /// Builds the data rows for the table.
  List<DataRow> _buildRows(BuildContext context,
      TransactionTableProvider provider, AccountProvider accountProvider) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return provider.transactions.map((transaction) {
      return DataRow(
        cells: [
          DataCell(Text(dateFormat.format(transaction.transactionDate))),
          DataCell(
              Text(_getAccountName(transaction.accountId, accountProvider))),
          DataCell(Text(transaction.to)),
          DataCell(
              Text('\$${transaction.transactionAmount.toStringAsFixed(2)}')),
          DataCell(Text(transaction.transactionCategory)),
          DataCell(Text(transaction.transactionType)),
          DataCell(Text(transaction.description)),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => TransactionDialog.show(
                    context,
                    transaction: transaction,
                  ),
                  tooltip: 'Edit Transaction',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmation(
                    context,
                    transaction,
                  ),
                  tooltip: 'Delete Transaction',
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  /// Shows a confirmation dialog before deleting a transaction
  Future<void> _showDeleteConfirmation(
      BuildContext context, TransactionModel transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content:
            const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final provider = context.read<TransactionProvider>();
      await provider.deleteTransaction(
        transaction.transactionId,
        NetworkConstants.testUserId,
      );
    }
  }

  Widget _buildFilters(
      BuildContext context, TransactionTableProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateFilter(context, provider),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToFilter(provider),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAmountFilter(provider),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeFilter(provider),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: provider.resetFilters,
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(
      BuildContext context, TransactionTableProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Date Range',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final DateTimeRange? dateRange =
                          await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialDateRange: provider.startDate != null &&
                                provider.endDate != null
                            ? DateTimeRange(
                                start: provider.startDate!,
                                end: provider.endDate!,
                              )
                            : null,
                      );
                      if (dateRange != null) {
                        provider.setDateRange(dateRange.start, dateRange.end);
                      }
                    },
                    child: Text(
                      provider.startDate != null && provider.endDate != null
                          ? '${DateFormat('dd/MM/yyyy').format(provider.startDate!)} - ${DateFormat('dd/MM/yyyy').format(provider.endDate!)}'
                          : 'Select Date Range',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToFilter(TransactionTableProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('To', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search recipient...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: provider.setToFilter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountFilter(TransactionTableProvider provider) {
    final minController = TextEditingController(
      text:
          provider.minAmount == 0 ? '' : provider.minAmount.toStringAsFixed(2),
    );
    final maxController = TextEditingController(
      text: provider.maxAmount == double.infinity
          ? ''
          : provider.maxAmount.toStringAsFixed(2),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Amount Range',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minController,
                    decoration: const InputDecoration(
                      labelText: 'Min Amount',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: maxController,
                    decoration: const InputDecoration(
                      labelText: 'Max Amount',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: minController,
                  builder: (context, minValue, _) {
                    return ValueListenableBuilder<TextEditingValue>(
                      valueListenable: maxController,
                      builder: (context, maxValue, _) {
                        final isEnabled = minValue.text.isNotEmpty ||
                            maxValue.text.isNotEmpty;
                        return ElevatedButton(
                          onPressed: isEnabled
                              ? () {
                                  final min =
                                      double.tryParse(minValue.text) ?? 0;
                                  final max = double.tryParse(maxValue.text) ??
                                      double.infinity;
                                  provider.setAmountRange(min, max);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(Icons.search),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilter(TransactionTableProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              value: provider.selectedType,
              hint: const Text('Select type'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All'),
                ),
                ...provider.transactionTypes.map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  ),
                ),
              ],
              onChanged: provider.setTransactionType,
            ),
          ],
        ),
      ),
    );
  }
}
