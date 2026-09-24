import 'package:flutter/material.dart';
import 'package:product_catalog/pages/dashboard_page.dart';
import 'package:product_catalog/pages/login_page.dart';
import 'package:product_catalog/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashRouter(),
    );
  }
}

class SplashRouter extends StatelessWidget {
  const SplashRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final loggedIn = snapshot.data ?? false;
        return loggedIn ? const DashboardPage() : const LoginPage();
      },
    );
  }
}
