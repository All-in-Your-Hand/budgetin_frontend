import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/transaction/presentation/transaction_injections.dart';
import '../../features/account/presentation/account_injections.dart';
import '../network/dio_config.dart';

final getIt = GetIt.instance;

void initInjections() {
  // Core
  getIt.registerLazySingleton<Dio>(() => DioConfig.createDio());

  // Features
  initTransactionInjections();
  registerAccountDependencies(getIt);
}
