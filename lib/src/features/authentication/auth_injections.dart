import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../core/utils/constant/network_constants.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/providers/auth_provider.dart';

void setupAuthInjections() {
  final getIt = GetIt.instance;

  // Configure Dio
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout:
          const Duration(milliseconds: NetworkConstants.connectionTimeout),
      receiveTimeout:
          const Duration(milliseconds: NetworkConstants.receiveTimeout),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Add an interceptor for error handling
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) {
        print('Dio Error: ${e.message}');
        print('Dio Error Type: ${e.type}');
        print('Dio Error Response: ${e.response}');
        return handler.next(e);
      },
    ));

    return dio;
  });

  // Register AuthRemoteDataSource
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );

  // Register AuthRepository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // Register AuthProvider
  getIt.registerFactory<AuthProvider>(
    () => AuthProvider(repository: getIt()),
  );
}
