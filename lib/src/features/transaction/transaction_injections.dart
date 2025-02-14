import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'data/data_sources/remote/transaction_remote_data_source.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'domain/repositories/transaction_repository.dart';
import 'presentation/providers/transaction_provider.dart';
import '../account/presentation/providers/account_provider.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/usecases/add_transaction_usecase.dart';

void setupTransactionInjections() {
  final getIt = GetIt.instance;

  // Data sources
  getIt.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(dio: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => AddTransactionUseCase(getIt()));

  // Providers
  getIt.registerFactory(
    () => TransactionProvider(
      repository: getIt(),
      addTransactionUseCase: getIt(),
    ),
  );
}

List<ChangeNotifierProvider> getTransactionProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<TransactionProvider>(
      create: (_) => getIt<TransactionProvider>(),
    ),
    ChangeNotifierProvider<AccountProvider>(
      create: (_) => getIt<AccountProvider>(),
    ),
  ];
}
