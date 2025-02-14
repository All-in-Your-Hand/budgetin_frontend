import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'data/data_sources/remote/transaction_remote_data_source.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/usecases/add_transaction_usecase.dart';
import 'presentation/providers/transaction_provider.dart';

/// Sets up all transaction-related dependencies
void setupTransactionInjections() {
  try {
    final getIt = GetIt.instance;

    // Data sources
    getIt.registerLazySingleton<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(dio: getIt()),
    );

    // Repositories
    getIt.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(remoteDataSource: getIt()),
    );

    // Use cases
    getIt.registerLazySingleton(
      () => AddTransactionUseCase(repository: getIt()),
    );

    // Providers
    getIt.registerFactory(
      () => TransactionProvider(
        repository: getIt(),
        addTransactionUseCase: getIt(),
      ),
    );
  } catch (e) {
    print('Error setting up transaction injections: $e');
    rethrow;
  }
}

/// Returns all providers needed for transaction management
List<ChangeNotifierProvider> getTransactionProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<TransactionProvider>(
      create: (_) => getIt<TransactionProvider>(),
    ),
  ];
}
