import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/core/config/app_config.dart';
import 'src/core/utils/injections.dart';
import 'src/core/router/app_router.dart';
import 'src/core/config/web_scroll_behavior.dart';

void main() {
  AppConfig.initialize();
  initInjections();

  runApp(
    MultiProvider(
      providers: getAppProviders(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Budgetin',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      routerConfig: router,
      scrollBehavior: WebScrollBehavior(),
    );
  }
}
