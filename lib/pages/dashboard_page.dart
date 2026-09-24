import 'package:flutter/material.dart';
import '../pages/list_product.dart';
import '../pages/login_page.dart';
import '../services/auth_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 72,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            const Text('Inventory Dashboard', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListProduct()),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Manage Products'),
            ),
          ],
        ),
      ),
    );
  }
}
