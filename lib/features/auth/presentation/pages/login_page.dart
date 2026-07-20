import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/widgets/google_colored_logo.dart';

import '../../../../core/theme/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Selamat datang kembali!',
                  style: whiteTextStyle,
                ),
                backgroundColor: primaryColor,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gagal login: ${state.message}',
                  style: whiteTextStyle,
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: const Color(0xff042a27));
                  },
                ),
              ),
              // Dark Teal Gradient Overlay
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
              // Content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Star Emblem (Similar to splash screen)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff11998e).withOpacity(0.35),
                                  blurRadius: 40,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          // Outer square 1 (rotated 0)
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              border: Border.all(
                                color: const Color(0xffD4AF37).withOpacity(0.4),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          // Outer square 2 (rotated 45)
                          Transform.rotate(
                            angle: math.pi / 4,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                border: Border.all(
                                  color: const Color(0xffD4AF37).withOpacity(0.4),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          // Inner circle
                          Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff11998e),
                                  Color(0xff064e3b),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: const Color(0xffD4AF37).withOpacity(0.8),
                                width: 1.5,
                              ),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.bookOpen,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Title
                      Text(
                        "Masuk ke E-Quran",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
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
                      const SizedBox(height: 12),
                      // Subtitle
                      Text(
                        "Masuk dengan Google untuk mensinkronisasikan riwayat bacaan, zikir, dan menerima update notifikasi.",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      
                      // Login Button
                      state is AuthLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD4AF37)),
                            )
                          : InkWell(
                              onTap: () {
                                context.read<AuthBloc>().add(LoginWithGoogleEvent());
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 15,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const GoogleColoredLogo(size: 22),
                                    const SizedBox(width: 14),
                                    Text(
                                      "Lanjutkan dengan Google",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff14193F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              // Bottom Credits
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Dilindungi oleh Supabase & Firebase",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.4),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
