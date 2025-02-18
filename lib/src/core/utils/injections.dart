import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../features/transaction/transaction_injections.dart';
import '../../features/account/account_injections.dart';
import '../../features/authentication/auth_injections.dart';
import '../../shared/shared_injections.dart';
import '../network/dio_config.dart';
import '../utils/log/app_logger.dart';
import '../exceptions/dependency_injection_exception.dart';

/// Global GetIt instance for dependency injection
final GetIt getIt = GetIt.instance;

/// Initializes all dependencies for the application
///
/// This should be called at app startup, before running the app.
/// Throws [DependencyInjectionException] if initialization fails.
void initInjections() {
  try {
    // Core injections
    getIt.registerLazySingleton<Dio>(
      () => DioConfig.createDio(),
      dispose: (dio) => dio.close(),
    );

    // Feature injections
    setupTransactionInjections();
    setupAccountInjections();
    setupAuthInjections();
    setupSharedInjections();
  } catch (e, stackTrace) {
    AppLogger.error('DI', 'Failed to initialize dependencies: ${e.toString()}\n${stackTrace.toString()}');
    throw DependencyInjectionException('Failed to initialize dependencies', e);
  }
}

/// Returns all providers needed for the application
///
/// This method aggregates providers from all features and returns them as a list
/// to be used with a [MultiProvider].
///
/// Returns a list of [ChangeNotifierProvider]s that should be used at the root
/// of the application.
List<ChangeNotifierProvider> getAppProviders() {
  return [
    ...getAuthProviders(),
    ...getAccountProviders(),
    ...getTransactionProviders(),
    ...getSharedProviders(),
  ];
}
