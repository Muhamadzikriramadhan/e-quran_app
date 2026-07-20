import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helper/biometric_helper.dart';
import '../../../../core/theme/theme.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with SingleTickerProviderStateMixin {
  bool showBiometric = false;
  bool isAuthenticated = false;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _progressController.forward();
    
    isBiometricAvailable();
    _startSplashTimer();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _startSplashTimer() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    _initAuth();
  }

  Future<void> _initAuth() async {
    // 1. Cek sesi Supabase terlebih dahulu
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
      return;
    }

    // 2. Jika user sudah login, verifikasi biometrik jika terdaftar
    try {
      final bool hasBiometrics = await BiometricHelper().hasEnrolledBiometrics();
      if (!hasBiometrics) {
        // If biometrics are not enrolled or not supported, skip authentication and proceed to home.
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
        return;
      }
    } catch (e) {
      debugPrint("Error checking biometric enrollment: $e");
      // Fallback: if checking enrollment throws an error, bypass authentication to prevent blocking the user
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
      return;
    }

    while (!isAuthenticated) {
      try {
        isAuthenticated = await BiometricHelper().authenticate();
      } catch (e) {
        debugPrint("Authentication error: $e");
        // If a PlatformException is thrown (e.g. user canceled, locked out, or security credentials not set)
        // break the loop and show a fallback message or proceed depending on policy.
        // For security credentials not set, we bypass. For lockout/cancellation, we can let them retry.
        if (e is PlatformException && e.code == 'NotAvailable') {
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
          return;
        }
        
        // Show error notification and break out of loop to avoid freezing the app
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authentication error: ${e.toString()}")),
        );
        break;
      }

      if (!isAuthenticated) {
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Authentication Failed"),
              content: const Text("Please authenticate using your fingerprint to continue."),
              actions: [
                TextButton(
                  child: const Text("Retry"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    if (isAuthenticated) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    }
  }

  Future<void> isBiometricAvailable() async {
    showBiometric = await BiometricHelper().hasEnrolledBiometrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Teal Gradient Overlay (optimized transparency to reveal background pattern)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xff095650).withOpacity(0.85),
                    const Color(0xff042a27).withOpacity(0.90),
                    Colors.black.withOpacity(0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Islamic Pattern Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: IslamicPatternPainter(
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          // Perfectly Centered Emblem & Title content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Custom Rub el Hizb (8-pointed star) emblem with gold border
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow behind the emblem
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff11998e).withOpacity(0.35),
                              blurRadius: 45,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Outer square 1 (rotated 0 degrees)
                      Transform.rotate(
                        angle: 0,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            border: Border.all(
                              color: const Color(0xffD4AF37).withOpacity(0.4),
                              width: 1.8,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      // Outer square 2 (rotated 45 degrees for perfect 8-pointed star shape)
                      Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            border: Border.all(
                              color: const Color(0xffD4AF37).withOpacity(0.4),
                              width: 1.8,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      // Inner circle with gradient and gold border
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff11998e), // primaryColor
                              Color(0xff064e3b), // deep rich emerald green
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: const Color(0xffD4AF37).withOpacity(0.8),
                            width: 1.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.bookOpen,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  // Title E-Quran & Zikir
                  Text(
                    "E-Quran & Zikir",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    "Lantunan Suci & Dzikir Penyejuk Qalbu",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.75),
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Positioned Bottom Area (Loader, Biometrics, Version Info)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Smooth Custom Progress Bar
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Container(
                        width: 180,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 180 * _progressController.value,
                            height: 5,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff38ef7d), // bright neon green
                                  Color(0xff11998e), // primary teal
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff38ef7d).withOpacity(0.5),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  // Biometric Protection indicator
                  if (showBiometric) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fingerprint_rounded,
                          color: Colors.white.withOpacity(0.6),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Dilindungi dengan Biometrik",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  // Version Number
                  Text(
                    "Versi 1.0.0",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
