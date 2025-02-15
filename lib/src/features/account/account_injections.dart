import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'data/data_sources/remote/account_remote_data_source.dart';
import 'data/repositories/account_repository_impl.dart';
import 'domain/repositories/account_repository.dart';
import 'presentation/providers/account_provider.dart';

/// Sets up all account-related dependencies
void setupAccountInjections() {
  try {
    final getIt = GetIt.instance;

    // Data sources
    getIt.registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl(dio: getIt()),
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
    print('Error setting up account injections: $e');
    rethrow;
  }
}

/// Returns all providers needed for account management
List<ChangeNotifierProvider> getAccountProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<AccountProvider>(
      create: (_) => getIt<AccountProvider>(),
    ),
  ];
}
