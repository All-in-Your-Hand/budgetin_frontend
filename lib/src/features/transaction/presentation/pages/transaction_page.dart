import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constant/network_constants.dart';
import '../../../account/presentation/providers/account_provider.dart';
import '../../../../shared/presentation/widgets/app_scaffold.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_table.dart';
import '../../../../shared/presentation/widgets/web_responsive_layout.dart';

/// A page that displays a list of user transactions.
///
/// This page automatically fetches and displays transactions for the current user.
/// It handles loading states and error states appropriately, providing feedback
/// to the user about the current state of the data.
///
/// Key features:
/// * Automatically fetches transactions on initialization
/// * Displays transactions in a table format
/// * Provides error handling and retry functionality
/// * Allows adding new transactions via FAB
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

  /// Initiates the transaction and account data fetching process.
  ///
  /// This method is called after the widget is inserted into the widget tree.
  /// It fetches both transactions and accounts for the current user to ensure
  /// all necessary data is available for the transaction table.
  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const userId = NetworkConstants.testUserId; // TODO: Get from auth provider
      if (mounted) {
        context.read<TransactionProvider>().getTransactions(userId);
        context.read<AccountProvider>().getAccounts(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      body: Scaffold(
        body: WebResponsiveLayout(
          useFullWidth: true,
          child: Consumer<TransactionProvider>(
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
        ),
      ),
    );
  }
}
