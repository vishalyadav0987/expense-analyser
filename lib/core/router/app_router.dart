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

int _previousIndex = 0;

int _getRouteIndex(String location) {
  if (location.startsWith('/dashboard')) return 0;
  if (location.startsWith('/add-expense')) return 1;
  if (location.startsWith('/analyser')) return 2;
  return 0;
}

CustomTransitionPage _buildSmartAnimatedPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  // 1. Pata karo abhi kis tab par jaa rahe hain
  final newIndex = _getRouteIndex(state.uri.toString());

  // 2. Logic: Agar naya index purane se bada hai, matlab hum Right jaa rahe hain.
  // Agar chota hai, matlab hum wapas Left aarahe hain!
  final isMovingRight = newIndex > _previousIndex;

  // 3. Agli baar ke liye yaad rakho
  _previousIndex = newIndex;

  return CustomTransitionPage(
    key: ValueKey('${state.pageKey.value}_${state.uri.toString()}'),
    child: child,
    transitionDuration: const Duration(milliseconds: 350), // Smooth duration
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Calculate Starting Position
      // isMovingRight == true -> Screen Right (1.0) se aayegi
      // isMovingRight == false -> Screen Left (-1.0) se aayegi
      final begin = Offset(isMovingRight ? 1.0 : -1.0, 0.0);
      const end = Offset.zero;

      // Premium iOS style curve (bounce ya linear nahi, smooth easeInOut)
      const curve = Curves.easeInOutCubic;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        // Ek halka sa fade effect add kiya hai, Glassmorphism UI par kamaal lagta hai!
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,

  initialLocation: '/splash',

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
          pageBuilder: (context, state) =>
              _buildSmartAnimatedPage(context, state, const DashboardScreen()),
        ),

        GoRoute(
          path: '/add-expense',
          pageBuilder: (context, state) =>
              _buildSmartAnimatedPage(context, state, const AddExpenseScreen()),
        ),

        GoRoute(
          path: '/analyser',
          pageBuilder: (context, state) =>
              _buildSmartAnimatedPage(context, state, const AnalyserScreen()),
        ),
      ],
    ),
  ],
);
