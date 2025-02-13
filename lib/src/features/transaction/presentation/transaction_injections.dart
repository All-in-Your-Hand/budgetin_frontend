import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../data/data_sources/remote/transaction_remote_data_source.dart';
import '../data/repositories/transaction_repository_impl.dart';
import '../domain/repositories/transaction_repository.dart';
import 'providers/transaction_provider.dart';
import '../../account/presentation/providers/account_provider.dart';
import 'package:budgetin_frontend/src/features/transaction/domain/usecases/add_transaction_usecase.dart';

final getIt = GetIt.instance;

void initTransactionInjections(GetIt sl) {
  // Providers
  sl.registerFactory(
    () => TransactionProvider(
      repository: sl(),
      addTransactionUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AddTransactionUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(dio: sl()),
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
