import 'package:get_it/get_it.dart';
import 'package:budgetin_frontend/src/features/account/data/data_sources/remote/account_remote_data_source.dart';
import 'package:budgetin_frontend/src/features/account/data/repositories/account_repository_impl.dart';
import 'package:budgetin_frontend/src/features/account/domain/repositories/account_repository.dart';
import 'package:budgetin_frontend/src/features/account/presentation/providers/account_provider.dart';

/// Register account-related dependencies
void setupAccountInjections() {
  final getIt = GetIt.instance;

  // Data sources
  getIt.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSource(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(getIt()),
  );

  // Providers
  getIt.registerFactory<AccountProvider>(
    () => AccountProvider(getIt()),
  );
}
