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
      builder: (context, provider, _) => SingleChildScrollView(
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
                  DataCell(
                      Text(dateFormat.format(transaction.transactionDate))),
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
    );
  }
}
