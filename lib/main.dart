import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'src/core/utils/injections.dart';
import 'src/features/authentication/presentation/providers/auth_provider.dart';
import 'src/features/transaction/presentation/pages/transaction_page.dart';
import 'src/features/transaction/presentation/providers/transaction_provider.dart';
import 'src/features/account/presentation/providers/account_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all injections
  initInjections();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetIt.instance<AuthProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetIt.instance<TransactionProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetIt.instance<AccountProvider>(),
        ),
      ],
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
