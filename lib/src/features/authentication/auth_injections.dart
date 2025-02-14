import 'package:get_it/get_it.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/providers/auth_provider.dart';

void setupAuthInjections() {
  final getIt = GetIt.instance;

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
    () => AuthProvider(repository: getIt()),
  );
}
