import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../core/utils/log/app_logger.dart';
import '../../core/storage/storage_service.dart';
import 'data/data_sources/remote/account_remote_data_source.dart';
import 'data/repositories/account_repository_impl.dart';
import 'domain/repositories/account_repository.dart';
import 'presentation/providers/account_provider.dart';

/// Sets up all account-related dependencies in the dependency injection container.
///
/// This function is responsible for registering:
/// - Data sources (AccountRemoteDataSource)
/// - Repositories (AccountRepository)
/// - Providers (AccountProvider)
///
/// Throws an [Exception] if any registration fails.
void setupAccountInjections() {
  try {
    final getIt = GetIt.instance;

    // Data sources
    getIt.registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl(
        dio: getIt(),
        storage: getIt<StorageService>(),
      ),
    );

    // Repositories
    getIt.registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(remoteDataSource: getIt()),
    );

    // Providers
    getIt.registerFactory<AccountProvider>(
      () => AccountProvider(repository: getIt()),
    );
  } catch (e) {
    AppLogger.error('AccountInjections', 'Error setting up account injections: $e');
    rethrow;
  }
}

/// Returns a list of all providers needed for account management.
///
/// This method creates and returns a list of [ChangeNotifierProvider]s
/// that are required for the account feature to function properly.
///
/// Returns a [List<ChangeNotifierProvider>] containing the AccountProvider.
List<ChangeNotifierProvider> getAccountProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<AccountProvider>(
      create: (_) => getIt<AccountProvider>(),
    ),
  ];
}
