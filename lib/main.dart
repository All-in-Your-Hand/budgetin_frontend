import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/core/utils/injections.dart';
import 'src/features/transaction/presentation/pages/transaction_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all injections
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budgetin',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TransactionPage(),
    );
  }
}
