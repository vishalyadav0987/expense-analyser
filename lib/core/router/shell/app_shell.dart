import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/dashboard')) {
      return 0;
    }

    if (location.startsWith('/add-expense')) {
      return 1;
    }

    if (location.startsWith('/analyser')) {
      return 2;
    }

    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;

      case 1:
        context.go('/add-expense');
        break;

      case 2:
        context.go('/analyser');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: child,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Add"),

          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Analyser",
          ),
        ],
      ),
    );
  }
}
