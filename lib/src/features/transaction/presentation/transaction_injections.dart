import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../data/data_sources/remote/transaction_remote_data_source.dart';
import '../data/repositories/transaction_repository_impl.dart';
import '../domain/repositories/transaction_repository.dart';
import 'providers/transaction_provider.dart';

final getIt = GetIt.instance;

void initTransactionInjections() {
  // Data sources
  getIt.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
        remoteDataSource: getIt<TransactionRemoteDataSource>()),
  );

  // Providers
  getIt.registerFactory(
    () => TransactionProvider(repository: getIt<TransactionRepository>()),
  );
}

List<ChangeNotifierProvider> getTransactionProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<TransactionProvider>(
      create: (_) => getIt<TransactionProvider>(),
    ),
  ];
}
