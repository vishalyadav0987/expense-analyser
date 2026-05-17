import 'package:expense_analyser/core/router/shell/app_shell.dart';
import 'package:expense_analyser/core/router/shell/auth_shell.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/add_expense_screen.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/analyser_screen.dart';
import 'package:expense_analyser/presentation/sceeen/auth/boimteric_setup_screen.dart';
import 'package:expense_analyser/presentation/sceeen/auth/login_with_email.dart';
import 'package:expense_analyser/presentation/sceeen/auth/mpin_screen.dart';
import 'package:expense_analyser/presentation/sceeen/auth/verifyOtp_screen.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/dashboard_screen.dart';
import 'package:expense_analyser/presentation/sceeen/initalScreen/intial_setup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final bool isFirstTime = false;

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,

  initialLocation: isFirstTime ? '/setup' : '/splash',

  routes: [
    /// AUTH SHELL
    /// 0. INITIAL SPLASH / LOADING
    GoRoute(
      path: '/splash',
      builder: (context, state) => const Scaffold(
        backgroundColor: Color(0xFF08120E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4EDEA3)),
        ),
      ),
    ),

    GoRoute(
      path: '/setup',
      builder: (context, state) => const InitialSetupScreen(),
    ),

    /// 1. AUTH SHELL (For Login, OTP, MPIN, Setup)
    ShellRoute(
      builder: (context, state, child) {
        return AuthShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginWithEmail(),
        ),
        GoRoute(
          path: '/verify-otp',
          builder: (context, state) {
            // SDE3 Catch: Safely extract the email from state.extra
            final email = state.extra as String? ?? '';
            return VerifyotpScreen(email: email);
          },
        ),
        GoRoute(
          path: '/mpin',
          builder: (context, state) {
            // SDE3 Catch: Extract multiple parameters using a Map
            final args = state.extra as Map<String, dynamic>? ?? {};
            return MpinScreen(
              isSetupMode: args['isSetupMode'] ?? false,
              email: args['email'],
              otpAccessToken: args['otpAccessToken'],
              showBiometricPrompt: args['showBiometricPrompt'] ?? false,
            );
          },
        ),
        GoRoute(
          path: '/biometric-setup',
          builder: (context, state) => const BoimtericSetupScreen(),
        ),
        GoRoute(
          path: '/setup',
          builder: (context, state) => const InitialSetupScreen(),
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
