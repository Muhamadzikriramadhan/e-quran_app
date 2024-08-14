
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../helper/biometric_helper.dart';
import '../../shared/theme.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool showBiometric = false;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _initDelayed();
    _initAuth();
  }

  Future<void> _initAuth() async {
    isAuthenticated = await BiometricHelper().authenticate();
    setState(() {});

    await isBiometricAvailable();
  }

  Future<void> isBiometricAvailable() async {
    showBiometric = await BiometricHelper().hasEnrolledBiometrics();
    setState(() {});
  }

  void _initDelayed() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (isAuthenticated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
              (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/loading.json',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
              repeat: true,
              reverse: true,
              animate: true,
            ),
            const SizedBox(height: 14),
            Text(
              "E-Quran App", // Sample balance
              style: whiteTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}