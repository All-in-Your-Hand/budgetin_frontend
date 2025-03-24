import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'data/data_sources/remote/transaction_remote_data_source.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'domain/repositories/transaction_repository.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/providers/transaction_table_provider.dart';
import '../../core/utils/log/app_logger.dart';
import '../../core/storage/storage_service.dart';

/// Sets up all transaction-related dependencies in the dependency injection container.
///
/// This function registers:
/// - Remote data sources for transaction operations
/// - Transaction repository implementation
/// - Transaction provider for state management
/// - Transaction table provider for table UI state management
///
/// Throws an exception if registration fails.
void setupTransactionInjections() {
  try {
    final getIt = GetIt.instance;

    // Data sources
    getIt.registerLazySingleton<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(
        dio: getIt(),
        storage: getIt<StorageService>(),
      ),
    );

    // Repositories
    getIt.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(remoteDataSource: getIt()),
    );

    // Providers
    // registerFactory works well if TransactionProvider should be recreated
    // when the widget tree is rebuilt
    // Change to registerLazySingleton if we want to keep transactions in memory
    // across pages.
    getIt.registerFactory(
      () => TransactionProvider(
        repository: getIt(),
      ),
    );

    // Table provider for managing table-specific state
    getIt.registerFactory(
      () => TransactionTableProvider(),
    );
  } catch (e) {
    AppLogger.error('TransactionInjections', 'Error setting up transaction injections: $e');
    rethrow;
  }
}

/// Returns a list of all providers needed for transaction management.
///
/// This includes:
/// - TransactionProvider for managing transaction state
/// - TransactionTableProvider for managing table UI state
///
/// @return List of ChangeNotifierProvider instances configured for transaction management
List<ChangeNotifierProvider> getTransactionProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<TransactionProvider>(
      create: (_) => getIt<TransactionProvider>(),
    ),
    ChangeNotifierProvider<TransactionTableProvider>(
      create: (_) => getIt<TransactionTableProvider>(),
    ),
  ];
}
