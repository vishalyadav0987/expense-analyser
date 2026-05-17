import 'package:expense_analyser/application/auth/auth_bloc.dart';
import 'package:expense_analyser/application/auth/auth_event.dart';
import 'package:expense_analyser/application/auth/auth_state.dart';
import 'package:expense_analyser/core/locator/setup_locator.dart';
import 'package:expense_analyser/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AuthBloc>()..add(const AuthAppStarted()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,

        routerConfig: appRouter,

        title: 'SpendIQ',

        theme: ThemeData(useMaterial3: true),

        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              // 1. Initial & Loading States (Do nothing, let UI show loading)
              if (state is AuthInitial || state is AuthLoading) return;

              // 2. Unauthenticated -> Go to Login
              if (state is AuthUnauthenticated) {
                appRouter.go('/login');
              }
              // 3. OTP Sent -> Go to Verify OTP (Pass Email!)
              else if (state is AuthOtpSent) {
                // Notice hum push use kar rahe hain taaki user chahe toh
                // back aakar apna email correct kar sake.
                appRouter.push('/verify-otp', extra: state.email);
              }
              // 4. MPIN Setup -> Go to MPIN Screen (Setup Mode)
              else if (state is AuthMpinSetupRequired) {
                appRouter.go(
                  '/mpin',
                  extra: {
                    'isSetupMode': true,
                    'otpAccessToken': state.otpAccessToken,
                  },
                );
              }
              // 5. MPIN Login -> Go to MPIN Screen (Login Mode)
              else if (state is AuthMpinRequired) {
                appRouter.go(
                  '/mpin',
                  extra: {
                    'isSetupMode': false,
                    'email': state.email,
                    'showBiometricPrompt': state.showBiometricPrompt,
                  },
                );
              }
              // 6. Fully Authenticated -> Go to Dashboard!
              else if (state is AuthBiometricSetupRequired) {
                appRouter.go('/biometric-setup');
              }
              // 8. Fully Authenticated
              else if (state is AuthAuthenticated) {
                appRouter.go('/dashboard');
              }
            },
            child:
                child!, // This child is your current screen managed by GoRouter
          );
        },
      ),
    );
  }
}
