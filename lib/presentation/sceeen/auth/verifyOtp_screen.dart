import 'dart:async';
import 'dart:ui';

import 'package:expense_analyser/application/auth/auth_bloc.dart';
import 'package:expense_analyser/application/auth/auth_event.dart';
import 'package:expense_analyser/application/auth/auth_state.dart';
import 'package:expense_analyser/core/locator/setup_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyotpScreen extends StatefulWidget {
  final String email;
  const VerifyotpScreen({super.key, required this.email});

  @override
  State<VerifyotpScreen> createState() => _VerifyotpScreenState();
}

class _VerifyotpScreenState extends State<VerifyotpScreen> with CodeAutoFill {
  static const int otpLength = 4;

  final TextEditingController _otpController = TextEditingController();

  final FocusNode _otpFocusNode = FocusNode();

  String _otpCode = "";

  Timer? _verifyTimer;

  Timer? _resendTimer;

  int _seconds = 45;

  @override
  void initState() {
    super.initState();

    listenForCode();

    startResendTimer();
  }

  @override
  void dispose() {
    cancel();

    _otpController.dispose();

    _otpFocusNode.dispose();

    _verifyTimer?.cancel();

    _resendTimer?.cancel();

    super.dispose();
  }

  // AUTO FILL CALLBACK
  @override
  void codeUpdated() {
    if (code == null) return;

    setState(() {
      _otpCode = code!;
      _otpController.text = code!;
    });

    if (_otpCode.length == otpLength) {
      triggerAutoVerification();
    }
  }

  // VERIFY DELAY
  void triggerAutoVerification() {
    _verifyTimer?.cancel();

    _verifyTimer = Timer(const Duration(milliseconds: 600), verifyOtp);
  }

  // VERIFY OTP
  void verifyOtp() {
    FocusScope.of(context).unfocus();

    if (_otpCode.length != otpLength) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter valid OTP")));
      return;
    }

    // FIRE BLoC EVENT
    locator<AuthBloc>().add(AuthVerifyOtp(email: widget.email, otp: _otpCode));
  }

  // RESEND TIMER
  void startResendTimer() {
    _seconds = 45;

    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  // RESEND OTP
  void resendOtp() {
    setState(() {
      _otpCode = "";
      _otpController.clear();
    });

    startResendTimer();

    FocusScope.of(context).requestFocus(_otpFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4EDEA3);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF08120E),

        body: BlocConsumer<AuthBloc, AuthState>(
          bloc: locator<AuthBloc>(),
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
              // Clear OTP so they can try again
              setState(() {
                _otpCode = "";
                _otpController.clear();
              });
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Stack(
              children: [
                /// BACKGROUND
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF08120E),
                        Color(0xFF0F1D17),
                        Color(0xFF08120E),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                /// GREEN GLOW
                Positioned(
                  top: -120,
                  left: -80,
                  child: _buildGlow(color: primary, size: 260),
                ),

                /// BLUE GLOW
                Positioned(
                  bottom: -100,
                  right: -50,
                  child: _buildGlow(color: const Color(0xFFADC6FF), size: 220),
                ),

                SafeArea(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 250),

                    // BUTTON AUTO MOVES ABOVE KEYBOARD
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),

                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,

                      padding: const EdgeInsets.symmetric(horizontal: 24),

                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 80,
                        ),

                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const Spacer(),

                              /// ICON
                              Container(
                                width: 95,
                                height: 95,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primary.withOpacity(.08),
                                  border: Border.all(
                                    color: primary.withOpacity(.25),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.lock_person_rounded,
                                  color: primary,
                                  size: 42,
                                ),
                              ),

                              const SizedBox(height: 32),

                              /// TITLE
                              const Text(
                                "OTP Verification",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 14),

                              /// SUBTITLE
                              const Text(
                                "Enter the verification code sent to your mobile number",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF9FB2AA),
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 42),

                              /// OTP FIELD
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),

                                child: PinFieldAutoFill(
                                  controller: _otpController,

                                  focusNode: _otpFocusNode,

                                  currentCode: _otpCode,

                                  autoFocus: true,

                                  keyboardType: TextInputType.number,

                                  codeLength: otpLength,

                                  decoration: BoxLooseDecoration(
                                    radius: const Radius.circular(16),

                                    gapSpace: 12,

                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),

                                    strokeColorBuilder: FixedColorBuilder(
                                      primary,
                                    ),

                                    bgColorBuilder: FixedColorBuilder(
                                      const Color(0xFF13211B),
                                    ),
                                  ),

                                  onCodeChanged: (code) {
                                    if (code == null) return;

                                    setState(() {
                                      _otpCode = code;
                                    });

                                    if (_otpCode.length == otpLength) {
                                      triggerAutoVerification();
                                    } else {
                                      _verifyTimer?.cancel();
                                    }
                                  },

                                  onCodeSubmitted: (code) {
                                    setState(() {
                                      _otpCode = code;
                                    });

                                    verifyOtp();
                                  },
                                ),
                              ),

                              const SizedBox(height: 28),

                              /// RESEND
                              _seconds == 0
                                  ? TextButton(
                                      onPressed: resendOtp,
                                      child: Text(
                                        "Resend OTP",
                                        style: TextStyle(
                                          color: primary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Resend code in ",
                                            style: TextStyle(
                                              color: Color(0xFF9FB2AA),
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "00:${_seconds.toString().padLeft(2, '0')}",
                                            style: TextStyle(
                                              color: primary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                              const SizedBox(height: 40),

                              /// VERIFY BUTTON
                              GestureDetector(
                                onTap: isLoading ? null : verifyOtp,

                                child: Container(
                                  height: 62,
                                  width: double.infinity,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),

                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4EDEA3),
                                        Color(0xFF3BCB92),
                                      ],
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: primary.withOpacity(.35),
                                        blurRadius: 30,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),

                                  child: Center(
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                        : const Text(
                                            "Verify OTP",
                                            style: TextStyle(
                                              color: Color(0xFF062014),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),

                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// GLOW EFFECT
  Widget _buildGlow({required Color color, required double size}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),

      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(.18),
        ),
      ),
    );
  }
}
