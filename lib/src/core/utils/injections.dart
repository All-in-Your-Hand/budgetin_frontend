import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../features/transaction/presentation/transaction_injections.dart';
import '../network/dio_config.dart';

final getIt = GetIt.instance;

void initInjections() {
  // Core injections
  getIt.registerLazySingleton<Dio>(() => DioConfig.createDio());

  // Feature injections
  initTransactionInjections(getIt);
}
