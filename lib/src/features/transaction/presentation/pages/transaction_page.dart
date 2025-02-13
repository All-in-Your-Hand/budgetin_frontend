import 'package:budgetin_frontend/src/core/utils/constant/network_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_table.dart';

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
    _fetchTransactions();
  }

  /// Initiates the transaction fetching process.
  ///
  /// This method is called after the widget is inserted into the widget tree.
  void _fetchTransactions() {
    // TODO: Replace with actual userId from auth state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TransactionProvider>()
          .fetchTransactions(NetworkConstants.testUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
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
                    onPressed: () => _fetchTransactions(),
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
    );
  }
}
