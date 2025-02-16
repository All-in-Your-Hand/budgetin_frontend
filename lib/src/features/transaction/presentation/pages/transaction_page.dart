import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constant/network_constants.dart';
import '../../../account/presentation/providers/account_provider.dart';
import '../../../../shared/presentation/widgets/app_scaffold.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_table.dart';
import '../widgets/transaction_dialog.dart';

/// A page that displays a list of user transactions.
///
/// This page automatically fetches and displays transactions for the current user.
/// It handles loading states and error states appropriately, providing feedback
/// to the user about the current state of the data.
class TransactionPage extends StatefulWidget {
  /// Creates a new instance of [TransactionPage].
  const TransactionPage({super.key});

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
      const userId = NetworkConstants.testUserId; // TODO: Get from auth provider
      if (mounted) {
        context.read<TransactionProvider>().fetchTransactions(userId);
        context.read<AccountProvider>().getAccounts(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      body: Scaffold(
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
                      onPressed: _fetchData,
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
          onPressed: () => TransactionDialog.show(context),
          tooltip: 'Add new transaction',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
