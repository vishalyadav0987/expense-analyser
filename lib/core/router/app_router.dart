import 'package:expense_analyser/core/router/shell/app_shell.dart';
import 'package:expense_analyser/core/router/shell/auth_shell.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/add_expense_screen.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/analyser_screen.dart';
import 'package:expense_analyser/presentation/sceeen/auth/login_with_email.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/dashboard_screen.dart';
import 'package:expense_analyser/presentation/sceeen/initalScreen/intial_setup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final bool isFirstTime = false;

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,

  initialLocation: isFirstTime ? '/setup' : '/analyser',

  routes: [
    /// AUTH SHELL
    GoRoute(
      path: '/setup',
      builder: (context, state) => const InitialSetupScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AuthShell(child: child);
      },

      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) {
            return const LoginWithEmail();
          },
        ),
      ],
    ),

    /// APP SHELL
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },

      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) {
            return const DashboardScreen();
          },
        ),

        GoRoute(
          path: '/add-expense',
          builder: (context, state) {
            return const AddExpenseScreen();
          },
        ),

        GoRoute(
          path: '/analyser',
          builder: (context, state) {
            return const AnalyserScreen();
          },
        ),
      ],
    ),
  ],
);
