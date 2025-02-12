import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'providers/transaction_table_provider.dart';

void initTransactionInjections() {
  final getIt = GetIt.instance;

  // Register providers
  getIt.registerFactory<TransactionTableProvider>(
      () => TransactionTableProvider());
}

List<ChangeNotifierProvider> getTransactionProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<TransactionTableProvider>(
      create: (_) => getIt<TransactionTableProvider>(),
    ),
  ];
}
