import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/transaction_model.dart';

class TransactionTable extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionTable({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('From')),
            DataColumn(label: Text('To')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Note')),
          ],
          rows: transactions.map((transaction) {
            final dateFormat = DateFormat('dd/MM/yyyy');
            return DataRow(
              cells: [
                DataCell(Text(dateFormat.format(transaction.transactionDate))),
                DataCell(Text(transaction
                    .userId)), // This should be replaced with actual 'from' data when available
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
    );
  }
}
