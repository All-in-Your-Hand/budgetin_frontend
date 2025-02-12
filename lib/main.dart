import 'package:budgetin_frontend/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:budgetin_frontend/src/features/transaction/presentation/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'src/features/authentication/auth_injections.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupAuthInjections();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetIt.instance<AuthProvider>(),
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
