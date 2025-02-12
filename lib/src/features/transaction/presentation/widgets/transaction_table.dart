import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/models/transaction_model.dart';
import '../providers/transaction_table_provider.dart';

class TransactionTable extends StatelessWidget {
  final List<Transaction> transactions;

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

class _TransactionTableView extends StatelessWidget {
  const _TransactionTableView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionTableProvider>(
      builder: (context, provider, _) => Column(
        children: [
          _buildFilters(context, provider),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  sortColumnIndex: provider.sortColumnIndex,
                  sortAscending: provider.sortAscending,
                  columns: [
                    DataColumn(
                      label: const Text('Date'),
                      onSort: (columnIndex, _) {
                        provider.sort<DateTime>(
                          (transaction) => transaction.transactionDate,
                          columnIndex,
                        );
                      },
                    ),
                    DataColumn(
                      label: const Text('From'),
                      onSort: (columnIndex, _) {
                        provider.sort<String>(
                          (transaction) => transaction.userId,
                          columnIndex,
                        );
                      },
                    ),
                    DataColumn(
                      label: const Text('To'),
                      onSort: (columnIndex, _) {
                        provider.sort<String>(
                          (transaction) => transaction.to,
                          columnIndex,
                        );
                      },
                    ),
                    DataColumn(
                      label: const Text('Amount'),
                      onSort: (columnIndex, _) {
                        provider.sort<num>(
                          (transaction) => transaction.transactionAmount,
                          columnIndex,
                        );
                      },
                    ),
                    DataColumn(
                      label: const Text('Category'),
                      onSort: (columnIndex, _) {
                        provider.sort<String>(
                          (transaction) => transaction.transactionCategory,
                          columnIndex,
                        );
                      },
                    ),
                    DataColumn(
                      label: const Text('Type'),
                      onSort: (columnIndex, _) {
                        provider.sort<String>(
                          (transaction) => transaction.transactionType,
                          columnIndex,
                        );
                      },
                    ),
                    DataColumn(
                      label: const Text('Note'),
                      onSort: (columnIndex, _) {
                        provider.sort<String>(
                          (transaction) => transaction.description,
                          columnIndex,
                        );
                      },
                    ),
                  ],
                  rows: provider.transactions.map((transaction) {
                    final dateFormat = DateFormat('dd/MM/yyyy');
                    return DataRow(
                      cells: [
                        DataCell(Text(
                            dateFormat.format(transaction.transactionDate))),
                        DataCell(Text(transaction.accountId)),
                        DataCell(Text(transaction.to)),
                        DataCell(Text(
                            '\$${transaction.transactionAmount.toStringAsFixed(2)}')),
                        DataCell(Text(transaction.transactionCategory)),
                        DataCell(Text(transaction.transactionType)),
                        DataCell(Text(transaction.description)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(
      BuildContext context, TransactionTableProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateFilter(context, provider),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildToFilter(provider),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAmountFilter(provider),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTypeFilter(provider),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
