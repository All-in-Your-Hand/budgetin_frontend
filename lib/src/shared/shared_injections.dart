import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../core/utils/log/app_logger.dart';
import 'presentation/providers/sidebar_provider.dart';
import 'presentation/providers/right_sidebar_provider.dart';

/// Sets up all shared-related dependencies in the dependency injection container.
///
/// This function is responsible for registering:
/// - SidebarProvider for managing main sidebar state
/// - RightSidebarProvider for managing right sidebar state
///
/// Throws an [Exception] if any registration fails.
void setupSharedInjections() {
  try {
    final getIt = GetIt.instance;

    // Providers
    getIt.registerLazySingleton<SidebarProvider>(
      () => SidebarProvider(),
    );

    getIt.registerLazySingleton<RightSidebarProvider>(
      () => RightSidebarProvider(),
    );
  } catch (e) {
    AppLogger.error('SharedInjections', 'Error setting up shared injections: $e');
    rethrow;
  }
}

/// Returns a list of all providers needed for shared components.
///
/// This method creates and returns a list of [ChangeNotifierProvider]s
/// that are required for the shared features to function properly.
///
/// Returns a [List<ChangeNotifierProvider>] containing the SidebarProvider
/// and RightSidebarProvider.
List<ChangeNotifierProvider> getSharedProviders() {
  final getIt = GetIt.instance;

  return [
    ChangeNotifierProvider<SidebarProvider>(
      create: (_) => getIt<SidebarProvider>(),
    ),
    ChangeNotifierProvider<RightSidebarProvider>(
      create: (_) => getIt<RightSidebarProvider>(),
    ),
  ];
}
