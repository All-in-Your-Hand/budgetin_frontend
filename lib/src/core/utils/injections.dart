import 'package:budgetin_frontend/src/shared/presentation/providers/sidebar_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../features/transaction/transaction_injections.dart';
import '../../features/account/account_injections.dart';
import '../../features/authentication/auth_injections.dart';
import '../network/dio_config.dart';
import '../../shared/presentation/providers/right_sidebar_provider.dart';

/// Global GetIt instance for dependency injection
final getIt = GetIt.instance;

/// Initializes all dependencies for the application
///
/// This should be called at app startup, before running the app
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

    // Register RightSidebarProvider as a singleton
    getIt.registerLazySingleton(() => RightSidebarProvider());

    // Register SidebarProvider as a singleton
    getIt.registerLazySingleton(() => SidebarProvider());
  } catch (e) {
    print('Error initializing dependencies: $e');
    rethrow;
  }
}

/// Returns all providers needed for the application
List<ChangeNotifierProvider> getAppProviders() {
  return [
    ...getAuthProviders(),
    ...getAccountProviders(),
    ...getTransactionProviders(),
  ];
}
