import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../core/storage/storage_service.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/providers/auth_provider.dart';

/// Sets up all authentication-related dependencies
void setupAuthInjections() {
  try {
    final getIt = GetIt.instance;

    // Storage service
    if (!getIt.isRegistered<StorageService>()) {
      getIt.registerLazySingleton<StorageService>(
        () => StorageServiceImpl(),
      );
    }

    // Data sources
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: getIt()),
    );

    // Repositories
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: getIt()),
    );

    // Providers
    getIt.registerFactory<AuthProvider>(
      () => AuthProvider(
        repository: getIt(),
        storage: getIt(),
      ),
    );
  } catch (e) {
    print('Error setting up auth injections: $e');
    rethrow;
  }
}

/// Returns all providers needed for authentication
List<ChangeNotifierProvider> getAuthProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => getIt<AuthProvider>(),
    ),
  ];
}
