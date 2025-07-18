import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/models/transaction_model.dart';
import '../providers/transaction_table_provider.dart';
import '../providers/transaction_provider.dart';
import '../../../account/presentation/providers/account_provider.dart';
import '../../../../shared/presentation/providers/right_sidebar_provider.dart';
import '../../../../shared/presentation/widgets/custom_snackbar.dart';
import 'delete_transaction_dialog.dart';

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
      create: (_) => TransactionTableProvider()..initializeTransactions(transactions),
      child: const _TransactionTableView(),
    );
  }
}

/// The internal implementation of the transaction table view.
///
/// This widget is responsible for rendering the actual table and filter UI.
/// It's private because it's an implementation detail of [TransactionTable].
class _TransactionTableView extends StatefulWidget {
  const _TransactionTableView({Key? key}) : super(key: key);

  @override
  State<_TransactionTableView> createState() => _TransactionTableViewState();
}

class _TransactionTableViewState extends State<_TransactionTableView> {
  final ScrollController _filterScrollController = ScrollController();
  final ScrollController _tableScrollController = ScrollController();

  @override
  void dispose() {
    _filterScrollController.dispose();
    _tableScrollController.dispose();
    super.dispose();
  }

  /// Gets the account name for a given transaction, returning "(Deleted Account)" if not found.
  ///
  /// This helper method encapsulates the logic for looking up an account name by ID.
  /// It's used for both displaying and sorting the account column.
  String _getAccountName(String accountId, AccountProvider accountProvider) {
    return accountProvider.accounts
            .where((account) => account.id == accountId)
            .map((account) => account.accountName)
            .firstOrNull ??
        '(Deleted Account)';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TransactionTableProvider, TransactionProvider, AccountProvider>(
      builder: (context, tableProvider, transactionProvider, accountProvider, _) {
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
                  onPressed: () => transactionProvider.getTransactions(context.read<AuthProvider>().user?.userId ?? ''),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildFilters(context, tableProvider),
            if (tableProvider.transactions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No transactions found'),
              ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: _tableScrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: SingleChildScrollView(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: DataTable(
                            sortColumnIndex: tableProvider.sortColumnIndex,
                            sortAscending: tableProvider.sortAscending,
                            headingRowColor: WidgetStateProperty.all(const Color(0xFFFFF6DD)),
                            columnSpacing: 56.0,
                            horizontalMargin: 24.0,
                            dataRowMinHeight: 48.0,
                            dataRowMaxHeight: 48.0,
                            columns: _buildColumns(tableProvider, accountProvider),
                            rows: _buildRows(context, tableProvider, accountProvider),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the column definitions for the data table.
  List<DataColumn> _buildColumns(TransactionTableProvider provider, AccountProvider accountProvider) {
    return [
      _buildSortableColumn<DateTime>(
        'Date',
        provider,
        (transaction) => transaction.transactionDate,
      ),
      _buildSortableColumn<String>(
        'Account',
        provider,
        (transaction) => _getAccountName(transaction.accountId, accountProvider),
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
        'Notes',
        provider,
        (transaction) => transaction.description,
      ),
      const DataColumn(
        headingRowAlignment: MainAxisAlignment.end,
        label: Text('Actions'),
      ),
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
  List<DataRow> _buildRows(BuildContext context, TransactionTableProvider provider, AccountProvider accountProvider) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return provider.transactions.map((transaction) {
      return DataRow(
        color: WidgetStateProperty.all(
          Color(transaction.transactionType == 'EXPENSE' ? 0xFFFFE6E6 : 0xFFF0FFE6),
        ),
        cells: [
          DataCell(Text(dateFormat.format(transaction.transactionDate))),
          DataCell(Text(_getAccountName(transaction.accountId, accountProvider))),
          DataCell(Text(transaction.to)),
          DataCell(Text('\$${transaction.transactionAmount.toStringAsFixed(2)}')),
          DataCell(Text(transaction.transactionCategory)),
          DataCell(Text(transaction.transactionType)),
          DataCell(Text(transaction.description)),
          DataCell(
            SizedBox(
              width: double.infinity,
              child: _buildActionButtons(context, transaction),
            ),
          ),
        ],
      );
    }).toList();
  }

  /// Builds the action buttons (edit and delete) for a transaction
  Widget _buildActionButtons(BuildContext context, TransactionModel transaction) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.penToSquare, size: 16),
            onPressed: () =>
                _getAccountName(transaction.accountId, context.read<AccountProvider>()) != '(Deleted Account)'
                    ? context.read<RightSidebarProvider>().startEditing(transaction)
                    : CustomSnackbar.show(
                        context: context,
                        isSuccess: false,
                        message: 'Cannot edit transaction with deleted account',
                      ),
            tooltip: 'Edit Transaction',
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 1),
          IconButton(
            icon: const Icon(FontAwesomeIcons.trashCan, size: 16),
            onPressed: () async => await DeleteTransactionDialog.show(context, transaction: transaction),
            tooltip: 'Delete Transaction',
            color: Colors.red,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, TransactionTableProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Match DataTable's minimum width:
        // horizontalMargin (24 * 2) + columnSpacing (56 * 7) + minimum column widths
        const minWidth = 1172.0;
        return SingleChildScrollView(
          controller: _filterScrollController,
          scrollDirection: Axis.horizontal,
          child: Container(
            width: width < minWidth ? minWidth : width,
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 20,
                        fit: FlexFit.tight,
                        child: _buildToFilter(provider),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 25,
                        fit: FlexFit.tight,
                        child: _buildDateFilter(context, provider),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 20,
                        fit: FlexFit.tight,
                        child: _buildTypeFilter(provider),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 35,
                        fit: FlexFit.tight,
                        child: _buildAmountFilter(provider),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: provider.resetFilters,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        child: const Text('Reset Filters'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToFilter(TransactionTableProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search recipient...',
            prefixIcon: Icon(Icons.search, size: 20),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          onChanged: provider.setToFilter,
        ),
      ],
    );
  }

  Widget _buildDateFilter(BuildContext context, TransactionTableProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MenuAnchor(
          builder: (context, controller, child) {
            return SizedBox(
              height: 48, // Match TextField height
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: Colors.grey), // Match TextField border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0), // Match TextField border radius
                  ),
                ),
                onPressed: () async {
                  controller.close();
                  final dateRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: provider.latestTransactionDate,
                    initialDateRange: provider.startDate != null && provider.endDate != null
                        ? DateTimeRange(
                            start: provider.startDate!,
                            end: provider.endDate!,
                          )
                        : null,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          dialogTheme: DialogTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                              maxHeight: 600,
                            ),
                            child: child!,
                          ),
                        ),
                      );
                    },
                  );
                  if (dateRange != null) {
                    provider.setDateRange(dateRange.start, dateRange.end);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.startDate != null && provider.endDate != null
                            ? '${DateFormat('dd/MM/yyyy').format(provider.startDate!)} - ${DateFormat('dd/MM/yyyy').format(provider.endDate!)}'
                            : 'Select Date Range',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          menuChildren: const [], // We don't need menu children as we're using showDateRangePicker
        ),
      ],
    );
  }

  Widget _buildTypeFilter(TransactionTableProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          value: provider.selectedType,
          hint: const Text('All Types'),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Row(
                children: [
                  Icon(Icons.filter_list, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All Types',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ...provider.transactionTypes.map(
              (type) => DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          onChanged: provider.setTransactionType,
        ),
      ],
    );
  }

  Widget _buildAmountFilter(TransactionTableProvider provider) {
    final minController = TextEditingController(
      text: provider.minAmount == 0 ? '' : provider.minAmount.toStringAsFixed(2),
    );
    final maxController = TextEditingController(
      text: provider.maxAmount == double.infinity ? '' : provider.maxAmount.toStringAsFixed(2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                decoration: const InputDecoration(
                  labelText: 'Min',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: maxController,
                decoration: const InputDecoration(
                  labelText: 'Max',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: minController,
              builder: (context, minValue, _) {
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: maxController,
                  builder: (context, maxValue, _) {
                    final isEnabled = minValue.text.isNotEmpty || maxValue.text.isNotEmpty;
                    return ElevatedButton(
                      onPressed: isEnabled
                          ? () {
                              final min = double.tryParse(minValue.text) ?? 0;
                              final max = double.tryParse(maxValue.text) ?? double.infinity;
                              provider.setAmountRange(min, max);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      child: const Icon(Icons.search, size: 20),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
